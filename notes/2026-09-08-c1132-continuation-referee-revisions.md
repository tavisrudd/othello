# C1132 — continuation referee revisions

**Lane**: `continuation`
**Status**: queued; feedback recorded, mathematical claims not yet validated.

## Objective and provenance

Address the author's 2026-09-08 Astra/ChatGPT feedback on
`continuation-graph-rigidity`, concerning pinned commit `6488b6dc…`.
Recommendation: revise and resubmit, leaning positive for a specialist journal.
The reviewer found no invalidating main-theorem error; literature positioning
is the principal required revision. This task owns the new feedback response,
distinct from C1110's existing review closeout, C271's named-source diligence
and C273's Lean implementation.

The reviewer reports independent finite-field/exact-cover/NetworkX census
reproduction, without executing the locked Nix/Sage/nauty suite. Reported tuples
(automorphism order, (q-3)-cliques, parallel classes, resolutions):
q=5: (48,12,8,2); q=7: (24,180,1352,1); q=8: (144,48,16,2);
q=9: (48,28,4,1); q=11: (24,36,4,1). The q=13 cross-check also agreed.
For q=5,8: transitivity on two resolutions, geometric stabilizer orders 24,72,
and shared-block counts 12,0. These are external reports, not new repository
validation. Subjective grades (overall 65–75, correctness 85–90, positioning
30–45) are not acceptance criteria.

## Required corrections

1. Compare Bailey–Cameron–Praeger–Schneider, *The geometry of diagonal groups*,
   Propositions 2.4 and 2.6 (https://arxiv.org/html/2007.10726): large-clique and
   disjointness reconstruction of Latin-square partitions, and autoparatopisms.
   The triangle graph is a division-table Latin-square graph; explain precisely
   the additional puncturing and coupled quotient in the frame problem.
2. Verify and cite the argument in Lemma 2.2 of Francetić–Herke–McKay–Wanless,
   *On Ryser's conjecture for linear intersecting multipartite hypergraphs*.
   The intermediate non-star argument gives Delta<=k-1 and
   h<=k(Delta-1)+1<=(k-1)^2. Their stated lemma has a stronger covering-number
   hypothesis: cite the argument, not an unchanged application of the lemma.
   Reposition Lemma 3.1 as a standard multipartite specialization.
3. Add constant pairwise intersection size to the Deza weak-delta-system
   comparison; non-sunflower alone is insufficient.
4. Qualify four-point minimality as uniform in the introduction and Section 5
   heading: the q=3 triangle graph K4 has faithful ambient S4 action.
   Handle q=2 separately in Theorem 5.3: a singleton legal set does not force
   fixed triangle vertices. Run the pencil argument for q>=3.
5. Put the kernel/faithfulness argument into Theorem 1.1 before asserting
   order 24e, rather than only in Corollary 1.2.
6. In Theorem 7.2 stop at the first successful abstract cyclic-table witness,
   then test primitive field images, matching the implementation and
   O(q^3+qn^2) subsidiary bound.
7. Correct A. Dyshko to S. Dyshko (Serhii); distinguish additive MDS isometries
   accurately (https://arxiv.org/abs/1504.01355).

## Priority mathematical gate: five-clique bound

Independently verify, then integrate if sound: every non-tangent clique for a
Desarguesian projective frame has at most five vertices. Do not generalize this
claim to arbitrary finite projective planes.

Proposed argument preserved for checking:

- A tangent contains at most three clique points if a clique point lies outside
  it: the other three centres must connect those points separately. A clique
  of size at least six therefore has three points on some tangent and at
  least three outside it, by pigeonhole at a vertex among four centred lines.
- Send that tangent to infinity. Its centre t is ideal; normalize the others
  to u=(0,0), v=(1,0), w=(0,1). The frame condition excludes all triangle-side
  directions for t. For an outside legal point P=(a,b), c=1-a-b has abc!=0.
- The three ideal clique points are the directions Pu,Pv,Pw. Other outside
  points assign these directions to u,v,w by nonidentity S3 permutations;
  the identity yields P only.
- A transposition of r,s has candidate r+s-P. Two distinct transpositions
  have a triangle-side joining direction and agree at no centre, so their
  adjacency would require that forbidden direction to be t.
- Three-cycle candidates R=(c,a), S=(b,c) require ab+bc+ca=0. Each differs
  from P's assignment at every centre, so PR and PS must both have direction
  t. But det(R-P,S-P)=a^2+b^2+c^2-ab-bc-ca
  =(a+b+c)^2-3(ab+bc+ca)=1, in every characteristic.
- For a transposition and a cycle, relabel so the transposition swaps v,w.
  Its candidate (1-a,1-b) and fixed-u condition force a=b. Cycle candidates
  (c,a),(a,c) then join P in forbidden triangle-side directions when distinct.
  Thus three outside points are impossible.

Check all existence, uniqueness and degeneracy qualifications. Proposed sharp
F7 witness in the manuscript coordinates: (2,3),(2,4),(5,4),(6,2),(6,4).

If validated, update uniform rigidity, unique extension and recognition to
q>=9: tangent traces have q-3>5 vertices, centre recovery needs q-2>4, and
the four-vertex seed construction should survive. Audit all dependent claims,
algorithms, evidence maps and documentation. Positivity for q=9,11 then ceases
to depend on computation; the genuine q=8 exception makes the uniform cutoff
optimal. Keep the census with its revised evidentiary role.

## Further improvements, in priority order

1. Rebuild novelty around punctured four-partition recovery, second-quotient
   field compatibility, individual-map extension and the geometric bound if
   proved. Vertex count determines q and fixed-field frames are projectively
   equivalent. Retain both algebraic lemmas as standalone results.
2. State the coding extension corollary explicitly. For D=Fq minus {0,1} and
   Q=q-2, Cq={(x,y,x/y,(x-1)/(y-1)): x,y in D, x!=y} has length 4,
   size Q(Q-1), minimum distance 3 in the uniform range. It is not MDS over
   its natural Q-symbol alphabet (Singleton bound Q^2); Q need not be a
   prime power. Prove restriction is an isomorphism from
   Stab_{Sym(D) wr S4}(Cq) to Isom(Cq,d_H), including injectivity.
   Distinguish Hamming extension from the semilinear geometric identification.
   Verify Aut(G_K) isomorphic to S4 x C_e: normalized frame projectivities
   are defined over the prime field and commute with Frobenius.
3. Assess a frame-first reading path: model, five-clique bound, recovered
   classes, algebra; move general-k bounds afterwards if beneficial.
   Reconcile with C1110's structure advice rather than reorganizing blindly.
   Add a worked punctured-division-table completion example identifying
   missing rows, columns and symbols.
4. Add a supplied-field interface and recognition tests at q=16,25, including
   nontrivial Frobenius relabellings; also exercise supported q=9 if the
   cutoff drops. Keep performance and implementation claims bounded.
5. Display readable nonambient witnesses: an octahedral-graph permutation at
   q=5 and a q=8 representative with its action on the two resolutions.
   A full conceptual classification of q=8 is not required.

## Acceptance and scope

Produce an itemized referee response: accepted/corrected, rejected with
evidence, or explicitly deferred. Verify primary sources through the cache
and applicable literature-audit workflow before manuscript claims. Apply
style, annotation and reproducibility conventions when triggered. No new Lean
claim follows from an informal proof. Validate authority paper/evidence checks
and deterministic PDF; forward-sync intended public changes and validate the
existing standalone mirror under export conventions. No push or DOI action
is part of this allocation. Record the ej+tt closeout and mystery ledger.
