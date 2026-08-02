# C817 structural-mathematics upgrade — task-wide closeout

**Date:** 2026-08-02

**Lane:** `clebsch`

**Verdict:** all six subitems positive; research package complete; no manuscript
change authorized or made

## Exact verdict

C817 found a structural upgrade in every requested direction.  The six results
are frozen in separate human-proof reports with deterministic exact evidence:

| # | Frozen result | Proof/evidence packet |
|---|---|---|
| 1 | The code is canonically \(\mathbf F_8^{12}\); the three rank-36 orbitals are the Frobenius-conjugate scalars, with the exact ambient split, symplectic form, Schur field, absolute irreducibility, and nonsplit-torus cuspidal identification. | `notes/2026-08-02-c817-hidden-f8-module.md` |
| 2 | Weighted pair concurrence has exact reconstruction arity two: its concurrence-8 neighborhoods recover the passant matrix, and its mod-two operator recovers the code, projector, hidden field, and all six elliptic relations. | `notes/2026-08-02-c817-pair-concurrence-closure.md` |
| 3 | The 364 minimum words are one octahedral \(G/S_4\) family and three chord-indexed toric \(G/D_{24}\) families; the latter are punctured pencil conics \(y^2=r xz\). | `notes/2026-08-02-c817-toric-octahedral-geometry.md` |
| 4 | The abstract reconstructed group recovers its 14-point conic action; its 169 involutions, product relations, and normalizers recover all 183 points and lines of \(\operatorname{PG}(2,13)\), the conic polarity, and the old incidence matrix.  With #2, weighted pair data alone recovers the full marked plane and code. | `notes/2026-08-02-c817-intrinsic-conic-action.md` |
| 5 | An exact rank-28 positive-semidefinite integral certificate proves \(\omega(\Gamma)=\vartheta(\overline\Gamma)=5\) and classifies equality, replacing the 111,930-subset weight-eight leaf. | `notes/2026-08-02-c817-weight-eight-theta-certificate.md` |
| 6 | A global line-intersection moment reduces weight ten to two shapes; four \(D_{14}\)-orbits and 33 \(D_{28}\)-orbits then exclude them before depth five, replacing syndrome meet-in-the-middle enumeration. | `notes/2026-08-02-c817-weight-ten-moment-certificate.md` |

Every computational theorem in those rows has its own committed script, JSON
certificate, SHA-256 manifest, replay command, searched domain, and stop
condition.  Each packet records its cheap falsifier and `ej`, `tt`, and `ej2`;
subitem 6 additionally records the failed linear/quadratic syndrome-separator
route and the required `aa` pivot.

## Targeted literature and priority boundary

This was a bounded positioning audit, not a novelty closure.  It authorizes no
unqualified “new,” “first,” or “to our knowledge” wording.  In particular, no
forward-citation closure was attempted, and an absence below means only “not
located in the characterized sources and exact searches stated here.”

### Exact searches

The following primary-source searches were run verbatim on 2026-08-02:

1. `site:arxiv.org PGL(2,q) involutions conic polarity projective plane reconstruction`
2. `site:arxiv.org "passant lines" "internal points" binary code minimum distance`
3. `site:arxiv.org Lovasz theta conic tangent graph finite projective plane`
4. `site:arxiv.org Clebsch graph code conic PG(2,13)`

The first search located a directly relevant 2024 preprint that materially
tightens the precedence boundary.  The other searches produced no primary
source matching the exact C817 theta, moment, minimum-support, or pair-recovery
claims.  That negative search result is not an exhaustiveness claim.

### Characterized sources and read depth

- H. D. L. Hollmann and Q. Xiang, *Association schemes from the action of
  \(PGL(2,q)\) fixing a nonsingular conic in \(PG(2,q)\)*,
  [arXiv:math/0503573](https://arxiv.org/abs/math/0503573).  **Partial full-text
  read:** abstract, introduction, and Section 3 through the opening of Section
  4; targeted whole-text term screen.  Cached 34-page PDF,
  SHA-256 `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`.
  This is clear precedence for the conic-stabilizer embedding, sharply
  three-transitive conic action, cross-ratio orbit relations, and the
  hyperbolic/elliptic association schemes.

- A. L. Madison and J. Wu, *On Binary Codes from Conics in \(PG(2,q)\)*,
  [arXiv:1104.0324](https://arxiv.org/abs/1104.0324).  **Partial full-text
  read:** abstract, introduction, opening conic-geometry/polarity material,
  organization and conclusion/reference boundary; targeted whole-text screen
  for minimum distance/weight, reconstruction, theta/clique, torus, and
  octahedral terminology.  Cached 23-page PDF,
  SHA-256 `f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`.
  This is direct precedence for the passant--internal incidence code, its
  polarity operator, the \(PSL(2,q)\)-module viewpoint, and the dimension
  theorem.  Its stated target is dimension, not the q=13 minimum layer.

- P. Tranchida, *Triples of involutions in \(PGL(2,q)\) and their incidence
  geometries*, [arXiv:2411.10299](https://arxiv.org/abs/2411.10299).
  **Partial full-text read:** abstract, introduction, and Section 2 through the
  conic polarity dictionary; targeted whole-text screen for code, minimum
  distance/weight, pair data, association schemes, theta, and hypergraph
  reconstruction.  Cached 17-page PDF,
  SHA-256 `3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656`.
  This is direct precedence for the bijection between involutions and
  off-conic points and for the statement that an involution's axis is the
  polar of its center.  Consequently C817 must not present that dictionary as
  new.  The C817-specific claim is instead reconstruction of the entire marked
  plane from the abstract minimum-support structure via exact pair data.

- S. Ball and M. Lavrauw, *Arcs in finite projective spaces*,
  [arXiv:1908.10772](https://arxiv.org/abs/1908.10772).  **Partial full-text
  read:** abstract/contents and Section 7's coordinate-free lemma of tangents.
  Cached 30-page PDF,
  SHA-256 `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.
  This supplies a general tangent-polynomial baseline but does not directly
  address the passant code or any C817 certificate.

### Claim-by-claim boundary

| C817 package | Established baseline | Bounded-audit status |
|---|---|---|
| Hidden \(\mathbf F_8\) module | Conic incidence module and its binary dimension are established. | The exact \(\mathbf F_8\)-scalar algebra, three Gram scalars, and q=13 cuspidal reduction were not located; publication positioning still needs a deeper modular-representation audit. |
| Pair closure | The full elliptic association scheme and its cross-ratio relations are established. | Recovery of that scheme, incidence matrix, code, and plane from weighted pair concurrence was not located. |
| Toric--octahedral minimum words | Split/nonsplit conic-stabilizer geometry is classical. | The four q=13 minimum-word constructions and punctured-pencil parity theorem were not located.  The uniform all-q observation remains only an incidental discovery lead. |
| Intrinsic conic action | The conic action and involution/off-conic-point/polar-axis dictionary are established, including Tranchida's explicit formulation. | Abstract recovery of the full plane from the minimum hypergraph's weighted 2-section was not located; any future theorem must cite and separate the classical dictionary. |
| Weight-eight theta certificate | Lovász theta is a standard method, not audited here for priority. | The displayed integral rank-28 certificate and equality-kernel classification were not located. |
| Weight-ten moment certificate | The incidence code and polarity setting are established. | The global moment identity plus the two stabilizer reductions was not located. |

These boundaries are sufficient to rank possible integrations, but not to
publish a priority sentence.  Any selected theorem should receive a narrower
claim-specific audit before manuscript wording is proposed.

## Ranked integration-options memo

Scores run from 1 (low) to 5 (high).  For page cost, trust cost, and dilution
risk, lower is better.  This ranks mathematical options only; it neither
authorizes integration nor changes the Paper-IV theorem hierarchy.

| Rank | Candidate | Gain | Cleanliness | Page cost | Trust cost | Dilution | Recommendation if later authorized |
|---:|---|---:|---:|---:|---:|---:|---|
| 1 | Exact weight-eight theta certificate | 5 | 5 | 2 | 1 | 1 | Best direct replacement: removes a large finite leaf with one exact positive form and a short equality argument. |
| 2 | Weight-ten moment--stabilizer certificate | 5 | 4 | 3 | 2 | Replace syndrome meet-in-the-middle by the global identity and compact orbit table; retain its 33-row certificate as the only finite leaf. |
| 3 | Pair-concurrence closure | 5 | 5 | 3 | 2 | State exact arity two and the direct recovery of \(M\); this sharpens the existing reconstruction headline without first developing the whole plane. |
| 4 | Full intrinsic conic/plane recovery | 5 | 4 | 4 | 2 | Highest conceptual ceiling, but integrate only with #3 and with explicit citation of the classical involution--polarity dictionary. |
| 5 | Toric--octahedral minimum geometry | 4 | 4 | 3 | 2 | Strong explanatory replacement for representative labels; the toric parity proof is compact, while the octahedral construction needs more exposition. |
| 6 | Hidden \(\mathbf F_8\) module | 4 | 3 | 5 | 3 | Deepest algebraic upgrade but the largest narrative branch; prefer a short corollary or defer unless the paper is deliberately recast around the Bose--Mesner module. |

The lowest-risk package is ranks 1--2 alone.  The strongest reconstruction
package is ranks 3--4 together.  Ranks 5--6 are explanatory enrichments and
should not be allowed to displace the exact code theorem or widen Paper IV
into an all-q representation paper.

## Final adversarial and synthesis passes

### `ej` — strongest objection

Six positive results can still make a worse paper if all six are promoted.
The module, homogeneous minimum geometry, full plane reconstruction, theta
certificate, and moment certificate form several legitimate narratives, not
one automatically coherent exposition.  Moreover, the involution--polarity
dictionary is explicit recent prior art, so an overbroad intrinsic-recovery
headline would blur the actual contribution.  The closeout therefore rejects
wholesale integration and permits only the ranked, separately audited choices
above for later discussion.

### `tt` — theorem architecture

The results fall into one causal chain with two independent proof payoffs:

\[
 \text{minimum supports}
 \longrightarrow \text{weighted pairs}
 \longrightarrow (M,G,\operatorname{PG}(2,13),\perp,\mathcal C),
\]

while the recovered cyclic/stabilizer symmetry supplies exact positive-form
and moment certificates for the two distance exclusions.  The hidden
\(\mathbf F_8\) module and toric--octahedral families explain why this chain
has the observed algebra and equality cases.  Thus a later paper can choose
either “finite leaves become structural certificates” or “the minimum layer
recovers its ambient geometry” without needing both narratives at full size.

### `ej2` — second-order consequence

The strongest consequence is not merely that the minimum-support hypergraph
has automorphism group \(PGL(2,13)\).  Its **weighted 2-section** already
determines the incidence matrix, code, all elliptic orbitals, 14-point conic,
183-point/line plane, and conic polarity.  Hence neither triples nor a supplied
ambient coordinate model are required.  This exact arity-two statement is the
proper conceptual endpoint and sharply separates C817 from the classical
existence of the conic action.

## Mystery ledger and stop boundary

Settled:

- all six requested subitems and their exact evidence boundaries;
- exact reconstruction arity two;
- both structural distance exclusions;
- the classical precedence boundary for conic actions, incidence modules, and
  involution/polarity geometry;
- the ranked set of possible later integrations.

Open, and not silently promoted into new work:

- a claim-specific citation-graph/full-text novelty closure for any theorem
  actually selected for publication;
- a basis-free association-algebra explanation of the theta matrix;
- a basis-free/Terwilliger compression of the 33 weight-ten stabilizer rows;
- the conceptual reason the octahedral and toric Gram data meet the same
  \(\mathbf F_8\) scalar package;
- whether the uniform punctured-pencil codewords beyond q=13 are already
  standard;
- manuscript selection, page budget, theorem hierarchy, formalization, and a
  fresh post-integration cold read.

C817 stops here.  No file under `papers/q13-passant-code/`, no release surface,
and no manuscript theorem or novelty sentence was changed.
