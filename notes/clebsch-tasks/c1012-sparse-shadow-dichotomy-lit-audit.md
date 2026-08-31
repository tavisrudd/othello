# C1012 — Sparse-shadow dichotomy mathematics and literature audit

**Lane:** clebsch  
**Status:** focused research pass complete; two new exact strengthenings frozen.  
**Scope:** no manuscript or Ergodis source files were edited.

## Executive verdict

The theorem package is clean, but its algebraic core must be presented as an
application of coherent-configuration theory rather than a new general
theorem. The programme contributes new geometric instances, quantitative
marking fibres, one useful priority-leverage upgrade, and one candidate
priority-judo bridge:

1. **Paper IV:** the \(q=13\) elliptic scheme is fusion-primitive. Every
   nonempty proper union of its six off-diagonal relations has coherent
   closure equal to the complete rank-seven scheme.
2. **Paper V:** finite-field binary-quartic orbit theory already contains the
   square-class calculation behind the quartic Gram character. Combining that
   calculation with harmonic-preserver theory answers a different question
   not treated there: exactly when the metric shadow is the harmonic design,
   and why it forgets the \(A_5\) marking.

One example is maximally resistant to fusion; the other forgets exactly the
subgroup marking that the geometry needs.

## 1. Three reconstruction levels

Let \(\Omega\) be finite, let \(\mathcal C\) be a marked carrier, and let
\(S=(M_1,\ldots,M_t)\) be pair matrices derived from it. Write

- \(\operatorname{Coh}(S)\) for the smallest coherent algebra containing the
  \(M_i\);
- \(\mathcal X\) for the target coherent configuration;
- \(H=\operatorname{Aut}(\mathcal C)\) and
  \(K=\operatorname{Aut}(S)=\operatorname{Aut}(\operatorname{Coh}(S))\).

There are three separate questions:

1. Does \(S\) recover \(\mathcal X\)?
2. Does the realized configuration \(\mathcal X\) recover \(\mathcal C\)?
3. Do the intersection numbers of \(\mathcal X\), without its realized
   relations, determine \(\mathcal X\)?

These are coherent closure, geometric reconstruction, and separability. Only
the first two are needed for Papers IV and V. Invoking separability there
would add an unnecessary stronger claim.

Likewise, recovering all orbitals of \(H\) determines only its 2-closure
\(H^{(2)}\), unless \(H\) is 2-closed or additional carrier structure is
reconstructed. This is the group-theoretic ceiling on a pair-only shadow.

## 2. Positive theorem

### Theorem A — coherent-shadow reconstruction

Let \(\mathcal X\) be a coherent configuration on \(\Omega\), with coherent
algebra \(\mathscr A(\mathcal X)\), and suppose every shadow matrix \(M_i\)
lies in \(\mathscr A(\mathcal X)\). Then

\[
 \operatorname{Coh}(S)\subseteq\mathscr A(\mathcal X),
\]

so the shadow closure is a fusion of \(\mathcal X\). If equality holds, the
Hadamard-primitive \(0\)-\(1\) basis of \(\operatorname{Coh}(S)\) recovers all
basis relations of \(\mathcal X\). Any isomorphism-equivariant reconstruction
functor \(\mathcal X\mapsto\mathcal C\) therefore reconstructs the carrier
from \(S\).

The proof is the universal property of coherent closure followed by the
unique disjoint \(0\)-\(1\) basis of a coherent algebra.

If \(\mathcal X\) is a commutative \(d\)-class association scheme and a
symmetric \(M\in\mathscr A(\mathcal X)\) has \(d+1\) distinct eigenvalues on
the primitive-idempotent spaces, then

\[
 \mathbf Q[M]=\mathscr A(\mathcal X).
\]

Ordinary powers already recover the scheme. This is sufficient, not
necessary: eigenvalue collisions can make \(\mathbf Q[M]\) proper while
Hadamard/common-neighbor refinement still gives full coherent closure.

## 3. Negative theorem

### Theorem B — excess-automorphism obstruction

Let \(S\) be derived equivariantly from \(\mathcal C\), so \(H\le K\). If an
element of \(K\) moves the carrier marking, no isomorphism-equivariant
construction from \(S\) can recover that marking.

If the possible markings form the transitive \(K\)-set \(K/H\), the fibre
over \(S\) contains exactly

\[
 [K:H]
\]

marked candidates. Selecting one requires at least
\(\lceil\log_2[K:H]\rceil\) unrestricted binary bits; a constrained query
model may require more.

Indeed, a canonical reconstruction must be fixed by every automorphism of
\(S\), hence would give a \(K\)-fixed point of \(K/H\). Such a point exists
only when \(H=K\).

A proper coherent closure alone is not an impossibility proof. Honest
negative certificates require an excess automorphism moving the carrier, two
explicit carriers with the same shadow, or a proved nontrivial fibre.

## 4. Priority leverage I: \(q=13\) fusion-primitivity

The elliptic scheme on the \(78\) internal points has six off-diagonal
relations

\[
 \rho\in\{0,1,3,9,10,12\}.
\]

C1010 checked only the 15 complement representatives arising from Boolean
predicates of the five observed concurrence values. C1012 checks all \(31\)
complement representatives of nonempty proper unions of the six individual
relations. Every graph reaches coherent rank seven within at most three
refinement rounds.

Therefore

\[
 \boxed{\text{the \(q=13\) elliptic association scheme is fusion-primitive}.}
\]

If a nontrivial proper fusion existed, one of its nontrivial basis relations
would be a proper union of original relations, whose coherent closure would
remain inside that fusion. The exhaustive result rules this out. The
unavoidable rank-two fusion merging all off-diagonal relations is the only
proper fusion.

Combined with Paper IV:

> Every nontrivial unweighted union graph from the elliptic scheme determines
> the complete scheme and hence the marked projective plane, conic, and
> polarity.

This is certificate-assisted and fixed-field. An all-\(q\) classification
would require eigenmatrix or character-sum input.

## 5. Priority-judo candidate: the quartic Gram family

Let \(R=\nu_4(\mathbf P^1(\mathbf F_q))\), with \(q\) odd, in the invariant
five-dimensional quadratic module. Up to a nonzero scalar,

\[
 B(v_{[s:t]},v_{[u:v]})=(sv-tu)^4.
\]

For four distinct parameters normalized to
\((\infty,0,1,\lambda)\), expansion gives

\[
 \det\operatorname{Gram}
 =16\lambda^2(1-\lambda)^2(\lambda^2-\lambda+1),
\]

and hence

\[
 \boxed{\chi(\det\operatorname{Gram})
   =\chi(\lambda^2-\lambda+1).}
\]

This relation is \(\operatorname{PGL}_2(q)\)-invariant. Any proper subgroup
marking moved by \(\operatorname{PGL}_2(q)\) is therefore invisible to it.

Assume first that the characteristic is not three and put
\(\epsilon=\chi(-3)\). The standard quadratic character sum, followed by
removal of \(\lambda=0,1\), gives

\[
\begin{array}{c|ccc}
\text{Gram character}&+1&0&-1\\ \hline
\#\{\lambda\ne0,1\}&
(q-6-\epsilon)/2&1+\epsilon&(q-\epsilon)/2.
\end{array}
\]

The numbers of unordered four-sets are these counts multiplied by

\[
 \frac{|\operatorname{PGL}_2(q)|}{24}
 =\frac{q(q^2-1)}{24}.
\]

In characteristic three,
\(\lambda^2-\lambda+1=(\lambda+1)^2\): there is one zero normalized ratio,
\(q-3\) positive ratios, and no negative ratios.

At \(q=11\), \(\chi(-3)=-1\). The positive ratios are
\(-1,2,1/2\), precisely the harmonic orbit, and the four-set counts are

\[
 165\text{ positive},\qquad0\text{ zero},\qquad330\text{ negative}.
\]

Away from characteristic three, the positive Gram relation is *exactly* the
harmonic orbit if and only if

\[
 \boxed{q\in\{11,13\}.}
\]

Indeed, equality forces the positive-ratio count
\((q-6-\epsilon)/2\) to be three, hence \(q=11\) with \(\epsilon=-1\) or
\(q=13\) with \(\epsilon=1\); conversely \(3\) is a square in both fields,
so the three harmonic ratios \(-1,2,1/2\) are positive. At \(q=11\) there
is no zero class, while at \(q=13\) the two equianharmonic ratios form the
zero class.

Classical harmonic-preserver theory says that the permutations preserving
harmonic quadruples form \(\operatorname{P\Gamma L}_2(q)\). Over the prime
fields \(\mathbf F_{11}\) and \(\mathbf F_{13}\), this is
\(\operatorname{PGL}_2(q)\). Thus C1011's automorphism result follows
conceptually without its \(9!\) stabilizer audit.

For Paper V the intended matching stabilizer is \(A_5\), giving

\[
 [\operatorname{PGL}_2(11):A_5]=22.
\]

The unrestricted lower bound is five bits; the constrained pair-membership
model requires exactly eleven adaptive or fourteen nonadaptive queries.

This is a credible **latent-consequence priority-judo move**. Kaipa--Patanker--
Pradhan already derive the apolar square criterion
\(\chi(\lambda^2-\lambda+1)\) and count its finite-field solutions in their
binary-quartic/line-orbit classification. They do not formulate the Gram
shadow, its exceptional collapse to the harmonic design at \(q=11,13\), its
full permutation automorphism group, or the resulting failure to reconstruct
a proper-subgroup marking. Conversely, the harmonic-preserver literature does
not connect its design to this metric/apolar shadow. The judo is therefore not
the raw character sum; it is the cross-literature consequence that settles a
reconstruction question neither source asks.

Fusion-primitivity remains priority leverage rather than priority judo unless
an audit of the elliptic-scheme literature shows that it answers an explicit
question left open or unnoticed there.

## 6. Genuine priority-judo targets

A result should be called priority judo here if it does either of two things:

1. **Upward judo:** proves a broader theorem from which the classical ceiling
   becomes a corollary.
2. **Latent-consequence judo:** uses a classical theorem to answer a natural
   question that its authors and subsequent literature did not extract.

The quartic shadow above is a candidate of the second kind, subject to a final
citation audit. Credible targets of the first kind are:

1. **Cross-ratio coloring rigidity, including even-Veronese Gram shadows.**
   Classify the full permutation groups preserving anharmonic-invariant
   colorings of four-subsets obtained from a rational function of cross-ratio,
   with an explicit exceptional list. This would contain the classical
   harmonic-preserver theorem and the Gram colorings as special cases. For
   the rational normal curve of degree \(2m\), the normalized four-point Gram
   determinant is
   \[
   \bigl(1-(\lambda^m+(1-\lambda)^m)^2\bigr)
   \bigl(1-(\lambda^m-(1-\lambda)^m)^2\bigr).
   \]
   A general coloring-rigidity theorem that specializes both to harmonic
   quadruples and to these determinant colors would be genuine priority judo.
   The determinant identity alone is not enough; the full automorphism
   classification is the hard gate.
2. **All-\(q\) elliptic fusion classification.** Determine exactly which
   unions of elliptic relations generate the full coherent configuration for
   every odd \(q\). If the theorem classifies fusion-primitivity and all
   exceptional fusions uniformly, the \(q=13\) result and standard
   single-relation generation statements become corollaries. A bounded census
   would not meet the bar; the character/eigenmatrix proof is essential.
3. **A representation-theoretic weighted-shadow theorem with converse.** An
   if-and-only-if theorem for reconstruction of a \(G\)-stable extremal shell
   from its weighted 2-section, stated through spherical transforms and
   marking stabilizers, could qualify only if it genuinely derives the
   quotient-polynomial/coherent-generation results rather than restating
   them. At present this is a prospect, not an achieved move.

The first two are the best research directions. The all-\(q\) elliptic
classification is closer to the existing programme data; cross-ratio
coloring rigidity is broader and potentially more distinctive.

## 7. Programme trichotomy

| Source | Sparse shadow | Closure/fibre | Verdict |
|---|---|---|---|
| Paper IV, \(q=13\) | any nontrivial relation-union graph | full rank-seven scheme | maximally fusion-resistant |
| Paper V | quartic four-Gram character | harmonic relation with \(PGL_2(11)\) symmetry | 22-fold missing marker |
| Paper II | low-degree trade | faithful on matching carrier, nonfaithful off it | carrier-relative |

The honest general picture has three outcomes: full closure, excess-symmetry
impossibility, and carrier-relative faithfulness.

## 8. Literature audit and novelty boundary

### Coherent configurations

Coherent closure, schurity, and separability are classical. Relevant sources:

- I. Ponomarenko, *Permutation group approach to association schemes*,
  European J. Combin. 30 (2009), 1456–1476,
  <https://doi.org/10.1016/j.ejc.2008.11.005>.
- S. Evdokimov and I. Ponomarenko, *Separability Number and Schurity Number
  of Coherent Configurations*, EJC 7 (2000), R31,
  <https://doi.org/10.37236/1509>.

Theorem A is a tailored synthesis, not a new coherent-algebra theorem.
Novelty must come from the geometric reconstruction and specific shadows.

### Single-graph generation

Pattern-polynomial and quotient-polynomial graphs already formalize graphs
whose adjacency algebra is a symmetric association scheme:

- M. A. Fiol and S. Penjić, *On symmetric association schemes and associated
  quotient-polynomial graphs*, Algebraic Combinatorics 4 (2021), 947–969,
  <https://doi.org/10.5802/alco.187>.

Thus “one graph generates the Bose–Mesner algebra” is established
terminology. “One small graph reconstructs this marked finite geometry” is
the substantive application.

### Fusions

Fusion schemes and algebra automorphisms preserving ordinary and Hadamard
products are classical:

- T. Ikuta, T. Ito, and A. Munemasa, *On Pseudo-automorphisms and Fusions of
  an Association Scheme*, European J. Combin. 12 (1991), 317–325,
  <https://doi.org/10.1016/S0195-6698(13)80114-X>.

The term *fusion-primitive* is established and should replace invented
terminology for the \(q=13\) result.

### Pair shadows and 2-closure

Wielandt's 2-closure is exactly the largest permutation group with the same
pair orbitals. A modern source citing the 1969 notes is

- *2-closures of primitive permutation groups of holomorph type*, Open
  Mathematics 17 (2019), <https://doi.org/10.1515/math-2019-0063>.

Theorem B is elementary orbit–stabilizer/2-closure theory. New content is the
exact excess group and its interpretation as missing geometric markings.

### Weighted 2-sections

General hypergraph reconstruction from weighted 2-sections is an established
algorithmic problem and is NP-hard even under strong restrictions:

- *Weighted 2-sections and hypergraph reconstruction*, Theoretical Computer
  Science 915 (2022), 11–25,
  <https://doi.org/10.1016/j.tcs.2022.02.016>.

Our cases are highly symmetric islands of exact reconstructibility or
certified nonreconstructibility, not the first 2-section reconstruction
problem.

### Harmonic quadruples

Projective-line cross-ratio orbits and the harmonic-preserver theorem are
classical. A convenient proof is Proposition 4.21 in Peter Cameron's
*Projective and Polar Spaces*:
<https://cameroncounts.wordpress.com/wp-content/uploads/2015/04/pps1.pdf>.

The harmonic design and its automorphism group are not new. The useful bridge
is that the quartic metric Gram determinant produces exactly this relation,
proving Paper V's information-loss boundary.

The closest finite-field overlap is:

- K. Kaipa, N. Patanker, and P. Pradhan, *On the \(PGL_2(q)\)-orbits of lines
  of \(PG(3,q)\) and binary quartic forms*, arXiv:2312.07118 (v3, 2025),
  <https://arxiv.org/abs/2312.07118>.

They identify the degree-four rational normal curve with pure binary
quartics, use the apolar invariant \(I\), prove the square criterion, derive
\(36I=\beta^2(\lambda^2-\lambda+1)\), and count the square cases. Thus the
all-\(q\) square-character calculation must be cited as known/overlapping.
Their paper contains no discussion of four-set Gram shadows, harmonic
3-designs, full permutation automorphism groups, \(q=11\), \(A_5\) matchings,
or reconstruction fibres. The defensible new statement is the bridge and its
reconstruction consequence, especially the exact \(q\in\{11,13\}\)
harmonic-collapse classification.

## 9. Publication recommendation

Immediate upgrades:

- **Paper IV:** promote the parity graph as the human theorem; add
  fusion-primitivity as an exact computational corollary if that matches the
  paper's style.
- **Paper V:** use the harmonic-preserver theorem in the banked C1011
  proposition and retain the exact finite certificate as an audit.
- **Paper II:** use “carrier-relative faithfulness” as common vocabulary
  without forcing coherent-algebra machinery into its main proof.

The combined story is credible as a short standalone paper, but the best
version should add one of:

1. an all-\(q\) classification of elliptic relation-union generation;
2. an infinite family of fusion-primitive extremal schemes; or
3. a family theorem computing minimal marking indices for proper subgroup
   carriers inside \(\operatorname{P\Gamma L}_2(q)\).

Without one of these, the material is strongest as coordinated upgrades to
Papers IV and V plus a synthesis note.

## 10. Ergodis implications

The controller should distinguish ordinary polynomial generation, coherent
generation, and parameter-level separability. Useful additions would:

- compute coherent rank for every seed union;
- recognize fusion-primitivity from complement representatives;
- accept a target carrier group and report its excess-automorphism index;
- optimize restricted queries after a marking fibre is identified.

That would make it a reconstruction-gap auditor rather than only a Boolean
predicate searcher.

## Reproduction

    python3 notes/clebsch-tasks/c1012_quartic_shadow_counts.py --check
    python3 notes/clebsch-tasks/c1012_q13_fusion_primitive.py --check

The first certificate checks the count formulas for every odd prime through
\(101\). The second checks all \(31\) complement representatives of the
\(q=13\) relation-union graphs.
