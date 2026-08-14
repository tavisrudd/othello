# Gamma point-row paper reviewer and critic dossier

Date: 2026-08-13

Use: sealed cold-reader input only.

> **Isolation boundary.** Reviewers receive the frozen PDF, this dossier's
> assigned packet, and the cited public sources only. They do not receive task
> cards, research notes, previous reviews, proposed repairs, or other readers'
> reports. Remediation receives frozen reports and an adopted-finding ledger,
> not reviewer persona material.

The people named below are forecasts based on public research pages,
publication overlap, and current public roles. They are not claims of private
editorial knowledge, willingness, availability, or endorsement. Nobody has
been contacted.

## 1. Frozen review surfaces

- authority commit:
  `f73bcb4f837eed0aa8d512567b70c74534b1f61a`;
- manuscript:
  `papers/gamma-point-row/gamma_point_row.pdf`;
- PDF SHA-256:
  `ed5c6c5d98ab158164e4885e8fc3734060b5fa724290b78658a20dbf9e2bd8b8`;
- source gate: `make check`;
- first-pass exclusions: internal ledgers, verification scripts, research
  notes, prior audit messages, and proposed repairs.

Every reader in the first batch reviews this exact surface. Any mathematical
edit requires a new commit, PDF hash, and affected-packet rerun.

The first batch returned Q MINOR, F MINOR, and D MAJOR. All findings were
adopted and frozen in separate reports. The remediated second surface was:

- public title: *The Point-Class Rank Functional under Birational Wall
  Crossing: Exact One-Wall Identities toward the X × P² Problem*;
- authority commit: `eaa3ed9c9`;
- PDF SHA-256:
  `4e6287cbfec4cc7c43c7cbb9cb61567e2de8af3cd726d6178fff741be4182c8a`;
- length: 12 pages.

The final circulation surface is:

- public title: *The Point-Class Rank Functional under Birational Wall
  Crossing: Exact One-Wall Identities toward the X × P² Problem*;
- authority commit:
  `fec94f383044d1e96684d876ca26d0cfec5e091e`;
- PDF SHA-256:
  `d8bb7b7165b0a928d09d9a0bd6de628ce3b5853fae855ffe0deb52b304ff9f65`;
- length: 13 pages;
- source gate: `make check`;
- status: the ordinary-flop/adjacent-birational and quantum-VGIT focused
  reruns both returned GO. No theorem-level finding remains open on this
  surface.

The original major finding was removed from the claim surface: one global
signed punctual coefficient is now only a candidate shadow. The sufficient
theorem assumes factorwise rank-zero targets directly.

## 2. Editorial route

The most natural first route is **SIGMA**, an arXiv-overlay journal whose
public scope includes differential equations, algebraic geometry,
mathematical physics, and symplectic geometry. Its current public board lists
Christopher Woodward, whose quantum-cohomology background makes him the
clearest handling-editor forecast:

- journal scope and current board:
  <https://sigma-journal.com/about.html>;
- relevant precedent in the same journal: Iritani,
  *Global mirrors and discrepant transformations*, SIGMA 16 (2020), 032.

**International Mathematics Research Notices** is the stronger alternate if
the exact point-column theorem and the boundary-loss package survive cold
review as one coherent advance. Its public description seeks concise work of
current interest across mathematics:
<https://academic.oup.com/imrn/>.

SIGMA is the more realistic first route for the current 13-page specialist
package. This is a forecast, not a submission decision.

## 3. Ranked reviewer and critic slate

### 1. Hiroshi Iritani — strongest whole-paper referee forecast

**Selection evidence.** Iritani's Gamma integral structure supplies the point
row, his work frames the Riemann--Hilbert problem for quantum cohomology under
birational transformations, and his discrepant toric work is the closest
positive comparison at the formal/analytic interface. Kyoto University
currently lists him as Professor in differential geometry and algebraic
analysis/mathematical physics:
<https://www.math.kyoto-u.ac.jp/en/people/profile/iritani>.

**Packet.** Definitions and Sections 3, 5, and 7.

**Expected pressure.**

1. Is the point in the correct pairing slot, with no missing dimension sign?
2. Does the paper ever identify a formal decomposition with the intrinsic
   Gamma frame without a theorem?
3. Is the simple-wall corollary visibly conditional?
4. Does the incomplete-Gamma model establish only an abstract no-go?
5. Is the two-wall boundary object formulated in a category where its signed
   punctual coefficient is meaningful?

### 2. Thomas Reichelt or Christian Sevenheck — strongest D-module referee

**Selection evidence.** Reichelt's official Mannheim page lists
Fourier--Laplace/Radon comparison, GKZ systems, quantum D-modules, and
non-affine Landau--Ginzburg models:
<https://www.wim.uni-mannheim.de/hertling/team/prof-dr-thomas-reichelt/>.
Sevenheck's current page lists irregular Hodge theory, D-modules,
hypergeometric systems, mirror symmetry, and active 2024--2026 work:
<https://www-user.tu-chemnitz.de/~sevc/>.

**Packet.** Sections 5--7 only.

**Expected pressure.**

1. Check the incomplete-Gamma differential equation and continuation
   direction.
2. Check the Weyl-algebra Fourier convention and the shift/sign disclaimer.
3. Decide whether the localized Fourier--Laplace claim matches the cited
   four-term comparison exactly.
4. Challenge the asserted passage from punctual multiplicity to output
   generic rank.
5. Distinguish necessity of the unlocalized boundary triangle from
   sufficiency of the rank-zero-target hypothesis.

Reichelt is the slightly closer source-level choice; Sevenheck is the
stronger irregular/Stokes alternate.

### 3. Yuan-Pin Lee or Hui-Wen Lin — ordinary-flop referee

**Selection evidence.** Lee--Lin--Qu--Wang prove the ordinary-flop quantum
comparison used in Section 4. The current University of Utah directory lists
Yuan-Pin Lee as Professor:
<https://math.utah.edu/directory/people-info/lee.php>.

**Packet.** Section 4 and the ordinary-flop statements in the abstract,
introduction, and scope.

**Expected pressure.**

1. Does the published graph gauge act on the exact solution object used in
   the proof?
2. Is the point column genuinely classical for all pure-extremal degrees?
3. Is the pulled-back divisor positive on every nonextremal effective class
   needed by the recursion?
4. Does the coefficientwise formal transverse completion justify induction?
5. Does the manuscript avoid claiming descendant invariance?

### 4. Zengrui Gu, Song Yu, or Tony Yue Yu — source-critical simple-wall read

**Selection evidence.** Their 2025 preprint supplies the master-space Fourier
comparison which Section 3 extends by one exact point-column consequence.
They are the readers most likely to catch a misuse of the completed source,
the extremal specialization, or the mirror-coordinate pullback.

**Packet.** Section 3 only, with Gu--Yu--Yu Lemma 3.27; Propositions 4.21,
5.2, 5.9; Lemmas 5.8, 5.10, 5.13; and Theorems 5.5, 6.2.

**Expected pressure.**

1. Does Lemma 3.27 really give zero wall restriction for a common-open point?
2. Does base change preserve the Fourier isomorphism at the specialization?
3. Is applying Lemma 5.10 to `lambda a_p` legal in the completed source?
4. Does Fourier covariance yield the displayed homogeneous equation with the
   correct scalar and sign?
5. Do mirror-coordinate terms annihilate the point class for the stated
   support reason?

Because this packet directly derives a consequence from their new source,
one of the authors is a valuable critic even if an editor would prefer a more
independent anonymous referee.

### 5. Mark Shoemaker — strongest collaborator/critic, not preferred anonymous referee

**Selection evidence.** Shoemaker coauthors the standard-flip Gamma theorem
and the general discrepant toric continuation paper used in the manuscript.
His research page explicitly foregrounds Gamma-integral compatibility and
Gromov--Witten theory of toric birational transformations:
<https://sites.google.com/site/markshoemakermath/research>.

**Packet.** Section 3's conditional sectorial corollary, Section 8, and the
separate discrepancy-one correction note.

**Expected pressure.**

1. Is the boundary between the Shen--Shoemaker theorem and the paper's
   sectorial hypothesis exact?
2. Does the discrepancy-one repair affect any statement used here?
3. Is supported Euler orthogonality stated on a sector wide enough for the
   pairing flip?
4. Would a narrower theorem avoid the common-realization hypothesis?

Shoemaker is the first outreach choice for possible collaboration because
there is already a concrete correction note concerning his paper and the new
manuscript asks exactly the next Gamma/continuation question. If contacted,
he must be removed from any referee forecast.

### 6. Zengrui Han — Fourier/window critic and secondary collaborator candidate

**Selection evidence.** Han's current University of Maryland page lists
toric mirror symmetry and derived categories; his research page includes
analytic continuation of better-behaved GKZ systems and Fourier--Mukai
transforms:
<https://zengruihan.github.io/> and
<https://zengruihan.github.io/research/>.

**Packet.** Sections 6--8 and the literature-boundary paragraphs.

**Expected pressure.**

1. Is the distinction between aggregate Mellin--Barnes residues and
   coordinate terms necessary and correctly stated?
2. Does localized Fourier--Laplace lose exactly the kind of extension used
   by the point row?
3. Is any crepant Gamma/window result being generalized silently to a
   discrepant two-wall setting?
4. Is the signed punctual target correctly presented only as a candidate
   shadow requiring a marked blockwise comparison?

Han is a plausible collaborator for the two-wall residue theorem, but the
fit is more research-risk-heavy than the Shoemaker outreach. No probability
of acceptance is asserted.

## 4. Major-finding packets

### Packet Q — simple-wall quantum comparison

Read Section 3 and its source loci. A MAJOR is any failure of the
`lambda a_p` specialization argument, any unproved claim that centre
coordinates vanish, or any unconditional Gamma-frame statement.

### Packet F — ordinary flop

Read Section 4. A MAJOR is use of descendant invariance not present in the
source, an invalid positivity/completion recursion, or a claim beyond one
fixed continuation domain.

### Packet D — incomplete Gamma and Fourier boundary

Read Sections 5--6. A MAJOR is a wrong flat column, wrong continuation
orientation, wrong Fourier module, or a false identification of boundary
support with output rank.

### Packet T — two-wall theorem and exposition

Read the abstract, introduction, Sections 7--8, and theorem statements only.
A MAJOR is any sentence presenting the rank-zero-target hypothesis as proved,
any hidden global factorization consequence, or a reader being unable to
separate formal packets, sectorial lifts, and intrinsic Gamma sections.

## 5. Cold-read protocol

Each reader receives:

- the frozen PDF and its authority commit and SHA-256;
- exactly one packet, or an explicitly named pair;
- the instruction to locate the earliest unsupported implication;
- no proposed repair and no other report;
- the verdict scale GO / MINOR / MAJOR.

Each report must state:

1. the earliest failing sentence or implication;
2. the smallest counterexample, ambiguity, or missing hypothesis;
3. whether the principal theorem survives a local repair;
4. which downstream statements must be re-read;
5. whether the source/priority boundary remains accurate;
6. one strongest passage and one highest-friction passage.

After reports are frozen, the coordinator records adopted and rejected
findings before editing. Mathematical edits trigger every packet whose causal
chain passes through the change. A new surface is then committed, rebuilt,
hashed, and reviewed by fresh readers who do not see the first reports.

## 6. Acceptance matrix

| Packet | Required result before external circulation |
|---|---|
| Q | GO from a quantum-VGIT reader |
| F | GO from an ordinary-flop/GW reader |
| D | GO from a D-module/irregular-connection reader |
| T | at most MINOR from both a primary specialist and an adjacent algebraic geometer |

Any MAJOR blocks circulation. A MINOR affecting a theorem hypothesis,
coefficient ring, continuation domain, pairing orientation, or conditionality
requires a new frozen surface and focused rerun.

## 7. Contact and conflict boundary

No outreach is authorized by this dossier. If Mark Shoemaker is contacted
about the discrepancy-one correction or invited to collaborate, preserve one
clean message separating:

1. the precise source correction;
2. the exact common-point theorem;
3. the open sectorial/two-wall question;
4. the proposed level of involvement.

Do not imply that authorship is expected in exchange for checking a
correction. If Shoemaker or Han contributes substantively, remove that person
from the referee slate and record the contribution under the journal's
authorship and conflict rules.
