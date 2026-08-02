# C817 — Paper IV structural mathematics upgrade

**Lane:** `clebsch`  
**Status:** active; subitem 1 positive and frozen; mathematics research only;
manuscript integration requires later user discussion

## Current state

Subitem 1 is complete.  The modular Bose--Mesner action on
\(K=\ker A_0\) has image exactly \(\mathbf F_8\), with
\(K\cong\mathbf F_8^{12}\) and
\((A_9,A_{10},A_{12})=(\alpha,\alpha^2,\alpha^4)\).  The stronger ambient
primary split, canonical projector, trace/norm three-Gram resolution,
\(\mathbf F_8\)-symplectic form, exact Schur field, absolute irreducibility,
and minimal definition field are also frozen.  The ordinary conic-point heart
is excluded; a precise nonsplit-torus identification remains a subitem-3
Brauer-character gate.  Report and exact evidence bundle:
`notes/2026-08-02-c817-hidden-f8-module.md`.

The next gate is subitem 2, pair-concurrence coherent closure and minimal
reconstruction arity.

## Objective

Test whether the exact \(q=13\) passant-code theorem admits a compact structural
upgrade that explains more of the minimum layer, removes a finite leaf, or
strengthens reconstruction without widening the paper into the all-\(q\) or
all-\(k\) programs.

The current Paper-IV manuscript and release surface are read-only inputs. This
task freezes successful mathematics and reproducible evidence in a research
report. It must not edit the manuscript, alter the release theorem, or imply
paper promotion. Integration, page budget, theorem hierarchy, novelty wording,
formalization, and a new cold read are discussed only after the research verdict.

## Per-subitem protocol

Every numbered subitem below is a separate gated research pass, worked in the
listed expected-value order. For each subitem:

1. run the cheapest exact falsifier or structural diagnostic first;
2. if a claim survives, extract the strongest compact theorem and a human proof
   route, with exact computation used only at irreducibly finite leaves;
3. if the primary route fails, run `aa`, record distinct alternative attacks,
   and execute the highest-EV bounded alternative before closing the subitem;
4. run `ej`, then `tt`, then a distinct second-order `ej2` pass, whether the
   primary verdict is positive or negative;
5. record the verdict, proof/evidence boundary, novelty gate, cheapest remaining
   falsifier, and unresolved features in the task mystery ledger.

No subitem may be skipped merely because an earlier subitem succeeds. A cheap
negative is a valid result, but it does not waive `ej`, `tt`, or `ej2`.
Computational claims require a committed exact script, compact canonical output,
hashes, replay command, independent replay or a stated reason none exists, and
the exact searched domain and stop condition. Any surviving novelty claim gets
a targeted original-source and forward-citation audit before positioning.

## Subitems in EV order

### 1. Hidden \(\mathbf F_8\) module on the code

Let \(A_0\) be the passant relation and \(B=A_9\). The existing identities give

\[
 (I+B+B^2+B^4)|_{\ker A_0}=0,
 \qquad
 1+t+t^2+t^4=(t+1)(t^3+t^2+1).
\]

Compute the primary decomposition of \(B|_K\), beginning with
\(\dim(\ker A_0\cap\ker(B+I))\). If the fixed space vanishes, prove that
\(K\) is naturally \(12\)-dimensional over \(\mathbf F_8\), with
\(A_9,A_{10},A_{12}\) the three Frobenius-conjugate scalar operators. Explain
the origin of the structure in the modular Bose--Mesner algebra and use it to
reinterpret the three dihedral orbit Grams and their spanning theorem. If a
fixed component survives, classify the exact \(\mathbf F_2/\mathbf F_8\)
primary decomposition and decide whether it still gives a nontrivial theorem.

**Success gate:** a canonical module theorem that explains at least two of the
dimension \(36\), the squaring cycle, the three Gram operators, and orbit
spanning. A bare rank computation does not pass.

### 2. Pair-concurrence closure and minimal reconstruction arity

Start from the five weighted pair-concurrence colors, in which two elliptic
relations share concurrence \(6\). Compute their exact coherent closure and
automorphism group.

- If the closure splits the two merged relations, prove that the weighted
  2-section of the minimum-support hypergraph already reconstructs the full
  elliptic scheme.
- If it does not, prove the fusion obstruction and show that triple concurrence
  is the first intrinsic invariant that separates it.

**Success gate:** either a strictly stronger pair-only reconstruction theorem or
a sharp minimal-arity theorem explaining why triples are necessary. Merely
reprinting the six triple histograms does not pass.

### 3. Homogeneous geometry of the four minimum-word orbits

Identify the order-\(24\) dihedral stabilizers with split-torus normalizers in
\(\PGL(2,13)\), whose coset space has size
\(91=\binom{14}{2}\). Determine their suborbits on the \(78\) internal points
and test whether the three dihedral minimum-word families are exactly three
canonical chord-indexed \(12\)-point orbitals. Interpret the \(S_4\) family as
the exceptional octahedral homogeneous space and determine its intrinsic
\(12\)-point support construction.

**Success gate:** replace four representative-based orbit labels by an
equivariant construction, ideally the dichotomy “one octahedral family and
three chord-indexed toric families,” with stabilizers and support sizes derived
rather than enumerated.

### 4. Intrinsic recovery of the conic action

Starting from the already reconstructed group
\(G=\operatorname{Aut}(\mathcal H)\cong\PGL(2,13)\), recover its \(14\)
Sylow-\(13\) subgroups and their conjugation action. Prove precisely whether
this recovers the abstract \(\mathbf P^1(\mathbf F_{13})\), hence the
conic-point \(G\)-set, from the minimum hypergraph. Delimit sharply what remains
absent: a preferred equation, coordinate system, or full ambient plane
reconstruction.

**Success gate:** a noncircular intrinsic reconstruction theorem strictly
stronger than recovery of \(M\) as an unlabeled matrix.

### 5. Exact spectral obstruction for weight eight

Exploit the three-fibre \(\mathbf Z/14\)-translation symmetry of the
\(42\)-vertex tangent graph. Fourier-reduce its adjacency or complement to
fourteen small blocks and test exact Hoffman, Delsarte, Lovász-theta, or
symmetry-reduced semidefinite certificates for clique number at most five.

**Success gate:** a compact exact certificate with a readable mathematical
proof that replaces the \(111930\)-subset enumeration. A floating-point bound
or a larger opaque computation does not pass.

### 6. Terwilliger or exact-dual exclusion of weight ten

Encode the two fixed-point pencil profiles inside the local/Terwilliger algebra
of the elliptic scheme. Seek an exact integer-linear, semidefinite, moment, or
character-theoretic dual certificate proving that neither profile can satisfy
the binary incidence parity equations.

**Success gate:** one compact structural certificate covering both profiles and
independent of meet-in-the-middle syndrome enumeration. If no such certificate
survives the bounded alternatives, retain the existing finite leaf and record
the precise obstruction.

## Anti-dilution and ownership boundaries

- Do not compute a full weight enumerator, generalized-weight tables, or extra
  orbit histograms without a theorem-level explanatory role.
- Do not import C756's all-\(k\) conic-filling problem or imply a uniform
  minimum-distance theorem.
- Do not edit `papers/q13-passant-code/`, its Lean package, Paper I, or any
  release manifest during this task.
- A successful result is frozen first as mathematics. Paper integration,
  formalization, release timing, and public novelty claims require explicit
  follow-up discussion and authorization.

## Acceptance

The task closes with:

1. an exact verdict on all six subitems in EV order;
2. the required per-subitem `ej`, `tt`, `ej2`, and failure-triggered
   `aa` records;
3. reproducible evidence and human proof packets for every positive theorem;
4. a targeted novelty audit for every result proposed for later publication;
5. an integration-options memo ranking only successful results by mathematical
   gain, proof cleanliness, page cost, trust cost, and dilution risk; and
6. an explicit stop before any manuscript change.
