# C707 physics novelty and directions audit

**Lane:** clebsch  
**Search date:** 2026-07-31  
**Scope:** novelty positioning and physics consequences of the C707 golden
three-fermion / six-Majorana realization

## Bottom line

The broad ingredients are not new separately.

- Howard--Millson--Snowden--Vakil give the signed triangle-cubic map to the
  Segre threefold and identify its exceptional outer-\(S_6\) action.
- Gillespie--Ó Catháin--Praeger realize the same outer automorphism with a
  complex Hadamard matrix of order six.
- The equations \(\sum q_i=\sum q_i^3=0\) are the standard local anomaly
  equations for six left-handed Weyl fermions under one \(U(1)\), and the
  Segre/Clebsch anomaly varieties are explicit recent prior art.
- Slater transition amplitudes as determinants and closed class-D ground
  parity as a Pfaffian sign are standard free-fermion mechanisms.
- Fermionic multiparticle statistics can be emulated in photonic
  interferometers; determinant/permanent complementarity is also known.

What this bounded sweep did **not** locate is the exact synthesis proved in
C707: the real golden conference pair whose six Joubert amplitudes are at
once (i) exterior-cube transition amplitudes, (ii) Pfaffians of six signed
\(K_{3,3}\) Majorana Hamiltonians, and (iii) a physical realization of the
middle-layer outer transform with the sharp \(20+44\) Boolean boundary and
universal optimum spectrum \(\{2,4,4\}\).  This is a defensible positioning
statement, not a claim of priority or an exhaustive absence result.

The most consequential new bridge is exact:
\[
 \sum_T Z_T=0,
 \qquad
 \sum_T Z_T^3=0.
\]
The six oriented transition amplitudes are therefore a projective
anomaly-free six-Weyl charge vector.  Moreover,
\[
 \frac13(-3,-2,-1,0,1,3)
 \quad\longmapsto\quad
 (11,-10,-8,5,4,-2),
\]
where the right side is the familiar primitive chiral anomaly-free charge
assignment appearing in the gauge-theory literature.  The map is not only
an abstract identification of varieties: it produces that charge vector as
six measurable oriented three-fermion amplitudes (or six Majorana
Pfaffians), up to a common scale.

## Claim-by-claim novelty boundary

| C707 claim family | Closest prior art | Verdict after this sweep |
|---|---|---|
| Six signed triangle cubics land on the Segre cubic and carry the outer \(S_6\) action | Howard--Millson--Snowden--Vakil (2008), especially §§1.2, 2.1, 2.4 | **Classical / preempted as geometry.** Their displayed moduli map has the same colored-triangle cubic mechanism. |
| A six-by-six matrix intertwines the two six-point actions | Gillespie--Ó Catháin--Praeger (2018) | **Adjacent matrix precedent.** Their matrix is complex Hadamard with cube roots of unity and split-quaternionic symmetry, not the real golden conference/Naimark operator. |
| Segre coordinates are anomaly-free six-Weyl \(U(1)\) charges | Costa--Dobrescu--Fox (2019); Gripaios--Nguyen (2025/2026) | **Explicit prior art.** The recent papers identify the five-fermion Clebsch and six-fermion Segre varieties and distinguish vectorlike from chiral strata. |
| \(Z_T\) is a three-fermion transition amplitude | Terhal--DiVincenzo (2002) for determinant scattering | **Standard mechanism, operator-specific instance.** No golden/Joubert instance was located. |
| \(4Z_T\) is a class-D Majorana Pfaffian and its sign is ground parity | Kitaev; Grabsch--Cheipesh--Beenakker (2019) | **Standard mechanism, operator-specific family.** No signed-\(K_{3,3}\) golden family or common \(\{2,4,4\}\) spectrum was located. |
| The 20 balanced phase masks realize the outer transform, are order-two correlation-immune, and maximize all six protocols | Slice harmonic analysis is classical; cryptographic correlation immunity is classical | **No exact predecessor located.** The conjunction with free-fermion amplitudes and Majorana parity appears to be the distinctive part. |
| All lossless real phase masks give either zero or vectorlike Segre nodes; a contractive filter gives \((11,-10,-8,5,4,-2)\) | The target charge vector and the vectorlike/chiral distinction are known | **New operator consequence not located elsewhere.** The charge vector itself is not new; its production by this golden filter is the new bridge. |
| Exact hardware realization | Matthews et al. (2013) emulate arbitrary fermionic processes with photons; many generic programmable platforms exist | **Feasible route, not an existing C707 device.** No exact golden six-mode or signed-\(K_{3,3}\) implementation was located. |

The strongest manuscript-safe language is therefore:

> The underlying Segre map, outer action, anomaly variety, determinant
> scattering rule, and Pfaffian-parity rule are established separately in
> prior work.  We did not locate prior work combining them in the real
> golden conference instrument or proving its sharp phase-mask,
> correlation-immunity, and universal-spectrum statements.

## The anomaly mechanism

For a single \(U(1)\), six left-handed Weyl charges \(q_i\) cancel the
mixed gravitational anomaly and cubic gauge anomaly precisely when
\[
 \sum_iq_i=0,
 \qquad
 \sum_iq_i^3=0.
\]
C707 already proves these identities for the six outer amplitudes \(Z_T(x)\).
Consequently every rational control with \(Z(x)\ne0\) gives a rational point
of the physical anomaly variety.  Integer clearing produces an integral
charge assignment.  This statement is projective: common rescaling changes
the amplitude normalization or gauge-coupling convention, not the point of
the Segre cubic.

There is a sharp operational stratification.

1. For the 44 nonbalanced real \(\pm1\) phase masks, all six amplitudes
   vanish.
2. The 20 balanced masks give permutations of
   \((-8,-8,-8,8,8,8)\), the oriented lifts of the ten singular Segre
   nodes.  These are vectorlike assignments.
3. Unequal real attenuation reaches smooth chiral points.  The small witness
   \((-3,-2,-1,0,1,3)/3\) gives the primitive chiral vector
   \((11,-10,-8,5,4,-2)\).

Thus, within this particular instrument, lossless real phases are confined
to the singular vectorlike boundary, while chirality requires a
contractive/postselected filter.  That is an architecture-specific theorem,
not a universal statement that physical unitarity forbids chiral gauge
theories.

The Majorana reading makes the same bridge more physical.  Since
\(\operatorname{Pf}A_T=4Z_T\), the six conjugate class-D Hamiltonians obey
\[
 \sum_T\operatorname{Pf}A_T=0,
 \qquad
 \sum_T\bigl(\operatorname{Pf}A_T\bigr)^3=0.
\]
Their Pfaffians cannot vary independently.  At the common optimum all have
equal magnitude, so the linear identity forces three positive and three
negative ground-parity signs.  This explains the balanced parity syndrome
without enumerating the twenty masks.

## What the physics may imply or explain

### 1. An amplitude-to-charge transducer

The golden network gives an exact analog parametrization of anomaly-free
charge data.  A target rational charge vector on the Segre cubic can, away
from exceptional loci, be pulled back to path-filter settings by the
classical rational inverse.  The output is then certified either by
coherent Slater amplitudes or by Majorana Pfaffians.  This could become a
small experimental demonstrator of arithmetic gauge constraints: the
anomaly equations appear as identities among directly measured many-body
observables.

What it does **not** do by itself is generate a chiral gauge theory.  The
interferometer supplies a laboratory representation of its charge
arithmetic, not gauge fields, anomaly diagrams, or Standard-Model matter.

### 2. Why probability loses the essential physics

Occupation probabilities see \(Z_T^2\), whereas chirality, global charge
conjugation, Segre-node orientation, and Majorana ground parity depend on
the signs of \(Z_T\).  At the optimum all six probabilities are identical,
even though ten projective nodes and two orientations remain.  The example
therefore cleanly isolates a general lesson: intensity-only tomography can
erase precisely the sign data that distinguishes vectorlike/chiral or
even/odd-parity physics.  An interferometric phase reference or direct
parity readout is essential.

### 3. A constrained six-parity device

The six class-D networks form an algebraically locked family rather than
six independent parity bits.  Sweeping a diagonal control moves through
Pfaffian chambers; \(Z_T=0\) is the gap-closing wall for network \(T\).
The Segre identities constrain which walls and parity flips can coexist.
This suggests studying the chamber adjacency graph, simultaneous parity
switches, and whether loops around the singular node stratum produce a
protected parity pump or monodromy realizing the outer automorphism.

### 4. A route to \(U(1)^2\) anomaly families

Gripaios--Nguyen show that two \(U(1)\) factors with six fermions correspond
to lines on the Segre cubic: 15 plane components are nonchiral and six
degree-five del Pezzo components are chiral.  Two independently tunable
golden controls should therefore be sought whose projective amplitude span
is a line contained in the Segre cubic.  This turns their Fano-variety
classification into a concrete synthesis problem for coupled
interferometers or coupled Majorana-Pfaffian families.

### 5. A bosonic control experiment

For the same one-particle transfer block, fermions measure a determinant and
bosons a permanent.  Jabbour--Cerf prove general probability relations
between the two.  Computing the permanent side of the golden \(3\times3\)
blocks may reveal a complementary bosonic signature of the Segre nodes,
provide an experimental null test, or show exactly which part of the outer
geometry is genuinely antisymmetric.  Matthews et al.'s photonic emulator
offers a plausible platform because the same chip can simulate fermionic
statistics using entanglement across copies.

### 6. Low-order fault blindness and calibration

On the balanced layer, any chosen output sign is independent of every one
or two input phase signs.  This is not yet a quantum error-correcting code,
but it is a precise calibration property: all single-path and two-path
signed biases cancel, while the first signal is a three-path correlation.
The immediate task is to perturb the ideal masks and derive which coherent
and stochastic error channels remain invisible to first or second order.
Only after that noise analysis would claims about sensing, masking, or
fault tolerance be warranted.

### 7. Positive geometry and scattering amplitudes

Recent work also places Segre/Clebsch cubics in positive-geometry and
scattering-amplitude contexts.  This is a lower-confidence bridge: C707's
\(Z_T\) are literal quantum transition amplitudes but not presently known to
be particle-scattering amplitudes in the amplituhedron sense.  A useful test
would be to compare C707 chamber boundaries and canonical forms with the
known positive geometries before making any physics claim.

## Ranked next directions

1. **Invert the anomaly transducer.**  Implement the rational inverse from a
   primitive six-charge solution to a physical control \(\|x\|_\infty\le1\),
   classify its exceptional set, and minimize postselection cost.
2. **Lift to \(U(1)^2\).**  Solve for two-control lines on the Segre cubic
   and match the 15 nonchiral plus six chiral Fano components.
3. **Map Majorana parity chambers.**  Determine all gap-closing walls,
   simultaneous switches, chamber adjacency, and possible monodromy.
4. **Compute the golden permanent.**  Apply boson--fermion complementarity
   to the exact \(3\times3\) cross blocks and extract an experimental
   discriminator.
5. **Design a six-mode demonstration.**  Compare true fermions with the
   established photonic-emulation route; specify preparation, coherent sign
   readout, postselection rate, and tolerance to mode mismatch.
6. **Quantify robustness.**  Expand around the 20 phase masks and prove or
   disprove second-order immunity under realistic phase and loss noise.
7. **Only then pursue dark-sector interpretation.**  Use the generated
   charge vectors as inputs to established chiral \(U(1)\) model-building;
   do not infer particle phenomenology from the interferometer alone.

## Promoted primary sources and read depths

Two sources were read at full-text depth and eleven at targeted full-text
depth.  The cache entries below identify the exact bytes used.

1. B. Howard, J. Millson, A. Snowden, and R. Vakil, *A description of the
   outer automorphism of \(S_6\), and the invariants of six points in
   projective space* (2008).  **Depth:** full text, especially §§1.2,
   1.5--1.6, 2.1, 2.4.  It explicitly gives the colored-triangle cubic map,
   Segre equations, signed outer representation, and matching-variable
   inversion.  Cache key `10.1016/j.jcta.2008.01.004`; SHA-256
   `a875f0bccccc42db97703e9cadf52648a3f4e41b429abd0b05ef84bf6725043c`.
2. N. Gillespie, P. Ó Catháin, and C. Praeger, *Construction of the outer
   automorphism of \(S_6\) via a complex Hadamard matrix* (2018).
   **Depth:** full text.  Cache key `arXiv:1805.01273`; SHA-256
   `f5e7ecefeb2f3528b0099644d60486314c4b045e7d2e79657f4ccd7c73ad86d0`.
3. D. B. Costa, B. A. Dobrescu, and P. J. Fox, *General solution to the
   \(U(1)\) anomaly equations* (2019).  **Depth:** targeted full text,
   anomaly equations, six-fermion parametrization, and conclusions.  Cache
   key `arXiv:1905.13729`; SHA-256
   `90140fc4392c6ad0c64e17c91f1a20c7797208065e55e8f70fcb0c5b8901037f`.
4. D. B. Costa, B. A. Dobrescu, and P. J. Fox, *Chiral Abelian gauge
   theories with few fermions* (2020).  **Depth:** targeted full text,
   introduction, the six-charge example, dark-sector application, and
   conclusions.  Cache key `arXiv:2001.11991`; SHA-256
   `c0a90e66e133fd11cc87c4857f9e542ffadc60764d726c39b2ecf41d7f61b89c`.
5. B. Gripaios and K. Le Nguyen Nguyen, *Anomaly cancellation for a
   \(U(1)\) factor* (2025; JHEP 2026).  **Depth:** targeted full text,
   introduction, physics-to-geometry mechanism, Clebsch/Segre examples.
   Cache key `arXiv:2508.11583`; SHA-256
   `8e9db79edfc38f338ff29875d7b7d5d671af0dfdd2892639b0eaed2f5d5e3b82`.
6. B. Gripaios and K. Le Nguyen Nguyen, *Anomaly cancellation for two
   \(U(1)\) factors* (2026).  **Depth:** targeted full text, introduction,
   formulation, §4 Segre case, and discussion.  Cache key
   `arXiv:2607.09879`; SHA-256
   `d9e4e7905e270e31a01c6c3a05e11388650cfd40579b2bf98d2bd9820d2493b3`.
7. M. Jabbour and N. J. Cerf, *Boson--fermion complementarity in a linear
   interferometer* (2023/2026).  **Depth:** targeted full text, setup,
   determinant/permanent theorems, and conclusions.  Cache key
   `arXiv:2312.17709`; SHA-256
   `57e299c41729d839449d74522d73251702314e928b883645cdf50fe79c64fa45`.
8. J. C. F. Matthews et al., *Observing fermionic statistics with photons
   in arbitrary processes* (2013).  **Depth:** targeted full text, general
   mechanism, experiment, \(N\)-particle extension, and discussion.  Cache
   key `10.1038/srep01539`; SHA-256
   `cd5c414171e960b4030d8647ac5225c7ed975e5835aab7d160886d11ddaf0e9f`.
9. V. S. Shchesnovich and M. E. O. Bezerra, *Collective phases of identical
   particles interfering on linear multiports* (2017).  **Depth:** targeted
   full text, abstract, setup, higher-order interference, conclusions.
   Cache key `arXiv:1707.03893`; SHA-256
   `06a50b7312488f398f61e48b10c0197cc244c22466194c57c269cebfd4176707`.
10. A. Grabsch, Y. Cheipesh, and C. W. J. Beenakker, *Pfaffian formula for
    fermion parity fluctuations in a superconductor and application to
    Majorana fusion detection* (2019).  **Depth:** targeted full text,
    §2.2, as already recorded in C707.  Cache key `arXiv:1903.11498`;
    SHA-256
    `5a437fbe55049c7c65c8b528dbc9a75bd92da64320da0d543f35300029631a13`.
11. A. Kitaev, *Unpaired Majorana fermions in quantum wires* (2000/2001).
    **Depth:** targeted full text, the quadratic Majorana Hamiltonian and
    Pfaffian parity invariant, as previously recorded in C707.  Cache key
    `arXiv:cond-mat/0010440`; SHA-256
    `a1db22b1b020a4a7121b08e1a86a1cfd73d40d88688ea291976d42f523f9e692`.
12. B. M. Terhal and D. P. DiVincenzo, *Classical simulation of
    noninteracting-fermion quantum circuits* (2002).  **Depth:** targeted
    full text, §II determinant transition-amplitude derivation, as
    previously recorded in C707.  Cache key `arXiv:quant-ph/0108010`;
    SHA-256
    `71a6c85976f3697a24eb6c32219e6322915f4e2684cd772b25f4f67c3edb271a`.
13. Y. Filmus and E. Mossel, *Harmonicity and invariance on slices of the
    Boolean cube* (2015).  **Depth:** targeted full text, §§3.1--3.2 and
    9.1, as previously recorded in C707.  Cache key `arXiv:1507.02713`;
    SHA-256
    `05e249d4ef881fb30d21d88eca85e61c2fd2b9207cbd7c320cc8af2ffd3c6586`.

## Search protocol and coverage limits

The sweep used web and arXiv title/abstract search, then promoted the closest
primary sources to cached full text.  Every returned item in the first result
set for each query was screened.  The search interface did not expose stable
total-result counts, and the number of deduplicated screened records was not
preserved; this is a reproducibility limitation.

The exact query families were:

- `"Clebsch cubic" fermion Majorana Pfaffian quantum`;
  `"Joubert cubic" fermion Majorana quantum`;
  `"Segre cubic" fermion Majorana quantum interferometry`;
  `"Clebsch cubic" "Slater determinant"`.
- `anomaly cancellation "Segre cubic" six fermions U(1)`;
  `"Segre cubic" anomaly-free U(1) charges`;
  `"Clebsch cubic" anomaly cancellation fermions`;
  `algebraic geometry anomaly cancellation equations six chiral fermions cubic`.
- `"outer automorphism of S6" quantum information`;
  `"outer automorphism" S6 fermion physics`;
  `S6 outer automorphism quantum error correcting code`;
  `exceptional outer automorphism phase code interferometer`.
- `conference matrix fermionic linear optics determinant phase mask`;
  `equiangular tight frame fermion interferometer`;
  `conference matrix Majorana Hamiltonian Pfaffian`;
  `signed K3,3 Majorana Hamiltonian Pfaffian spectrum`.
- `correlation immune Boolean functions quantum information phase encoding`;
  `resilient Boolean function quantum secret sharing correlation immunity`;
  `correlation immune functions quantum circuits physical implementation`;
  `orthogonal array correlation immunity quantum error correction`.
- `experimental programmable fermionic linear optics six modes ultracold atoms`;
  `experimental three fermion multiport interference determinant`;
  `programmable fermionic quantum simulator mode mixing number resolved detection`;
  `Majorana coupling network programmable all to all six Majorana experiment`.
- `"Anomaly cancellation for a U(1) factor" arXiv`;
  `"Segre cubic" anomaly Majorana interferometer Slater determinant`;
  `"signed K3,3" Majorana fermion Hamiltonian`;
  `"outer automorphism of S6" Segre cubic Vakil`.
- `"Observing fermionic statistics with photons in arbitrary processes" DOI arXiv`;
  `fermion parity phase masks interferometer Majorana control signs Pfaffian`;
  `anomaly free charges squared signs reconstruction cubic equation`;
  `Segre cubic nodes vectorlike anomaly charges`.
- `"Segre cubic" "linear optics" fermion`;
  `"Clebsch cubic" quantum interferometer`;
  `Joubert cubic anomaly cancellation`;
  `"conference matrix" "outer automorphism" S6`.
- exact-coordinate searches combining
  `"11, -10, -8, 5, 4, -2"` with `Joubert`, `Segre cubic`, and `anomaly`,
  plus `"-3, -2, -1, 0, 1, 3" cubic map`.

Not covered: MathSciNet; systematic zbMATH screening; INSPIRE citation
closure; OpenAlex, Crossref, or Semantic Scholar forward/backward citation
graphs; dissertations and patents as a class; non-English full-text search;
or exhaustive hardware proceedings.  Google Scholar was not used.  The
very recent `arXiv:2607.09879` had only two weeks of possible citation
history on the search date.  These gaps are why the audit supports careful
positioning but not “first,” “unique,” or “no prior work” language.
