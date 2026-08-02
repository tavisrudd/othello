# C719 — Golden six-mode demonstrator design

**Lane:** `golden`

**Status:** complete

## Verdict

The complete photonic experiment is a **2026 hardware `NO-GO`**, for one
specific reason: the required totally antisymmetric state of three photonic
qutrits has a linear-optical preparation proposal but no experimental
realization was located.  The demonstrated two-photon emulator does not close
that gap.  Current three-qutrit experiments prepare different entanglement;
their best directly relevant benchmark has fidelity (0.910(6)) and about
(1.1) fourfold events per second, far short of what the small chiral branch
requires.

A bounded precursor is a **`GO`**: implement and phase-characterize the
six-mode Golden transfer with coherent light, then run the ordinary
three-boson collision-free controls.  This measures the calibrated transfer
and its determinant signs, but it must not be described as a direct
three-fermion phase measurement.  C765 should therefore begin as a compact
design-limit/theory note, not an experimental proposal.

## Platform and circuit

Choose the Matthews--Poulios--Meinecke entangled-photon emulator over native
fermions.  It gives one optical architecture for bosonic and fermionic
statistics, but for three particles it needs a symmetric or antisymmetric
three-qutrit resource shared across three identical copies of the one-particle
process.

In the C718 pivot gauge, put

\[
 O_T=[Q_{T,+}\ Q_{T,-}],\qquad
 U_T(x)=O_T^{\mathsf T}\operatorname{diag}(x)O_T.
\]

Inject into ports (0,1,2) and read the event in ports (3,4,5).  Its
three-by-three block is (K_T=Q_{T,-}^{\mathsf T}D_xQ_{T,+}).  The balanced
controls (x_i=\pm1) are lossless.  The chiral control is

\[
 x=\left(1,\frac7{13},\frac17,-\frac15,-\frac12,-1\right),
\]

implemented by six variable attenuators and (0/\pi) path phases.

The certificate gives a 15-Givens adjacent-mode decomposition of the base
(O), with convention

\[
G_{ab}(\theta)=
\begin{pmatrix}\cos\theta&\sin\theta\\-\sin\theta&\cos\theta\end{pmatrix}
\]

on modes (a,b), and reconstructs (O) to maximum entry error
(1.7\times10^{-15}).  A balanced six-mode unitary uses at most 15 tunable
Mach--Zehnder cells per copy.  The filtered SVD implementation uses two such
meshes and six attenuators per copy.  Three spatially parallel emulator copies
therefore use 18 modes and at most 45 balanced or 90 filtered MZIs; time-bin or
frequency copies may reuse the same physical mesh.  The other five protocols
are the six frozen path permutations recorded in the certificate; odd
representatives exchange the two three-port halves and transpose (K).

## Ideal readings

At a balanced mask the fermionic amplitude and event probability are

\[
 |\det K_T|=\frac4{5\sqrt5},\qquad P_F=\frac{16}{125}=0.128.
\]

In the calibrated bosonic port gauge the collision-free probabilities are

\[
 P_B\in\left\{\frac{16}{3125},\frac{36}{3125},
                    \frac{64}{3125}\right\}.
\]

The basis-free upgrade averages the ten normalized bosonic inputs and gives
(h_3/10=313/1250); together with (P_F=16/125) and the one-particle trace
(9/5), it certifies the spectrum ({1/5,4/5,4/5}).  This ten-input
upgrade is optional for the minimal demonstrator; the collision-free control
is the cheaper first experiment.

For the chiral filter,

\[
 Z=\frac{72}{455}(11,-10,-8,5,4,-2),qquad
 P_{F,T}=\frac{(72/455)^2q_T^2}{500}.
\]

The six probabilities range from (156816/25878125\simeq0.00606) down to
(5184/25878125\simeq2.00\times10^{-4}).  The smallest branch, not the
balanced experiment, sets the resource threshold.

## Sign readout and falsifiable identities

The feasible sign readout is coherent transfer tomography.  Six single-input
intensity settings determine moduli; five two-input phase scans against a
fixed reference determine all nontrivial phases.  With input and output port
phases fixed, the real determinant of the measured (K_T) has a calibrated
sign.  This is exactly the demonstrated six-by-six characterization method of
Rahimi-Keshari et al.; it is not a direct observation of the global phase of a
many-photon amplitude.

For contraction blocks,

\[
 |\det(K+E)-\det K|\le 3\lVert E\rVert_2.
\]

Consequently the balanced sign is certified by
(lVert E\rVert_2<0.1193).  The smallest chiral sign needs
(lVert E\rVert_2<0.00472), and a ten-percent measurement of that amplitude
needs (4.72\times10^{-4}).  The latter is a transfer-tomography requirement,
not merely a phase-shifter specification.

Diagonal real loss replaces (x) by another real filter and preserves

\[
 sum_T Z_T=\sum_T Z_T^3=0
\]

exactly.  Diagonal coherent phase error preserves the polynomial identities
over (mathbf C), although a literal real sign then requires the phase
reference.  Uniform amplitude transmission (lambda) scales amplitudes by
(lambda^3) and probabilities by (lambda^6).  Mesh error or mismatch
between emulator copies is different: it leaves the common Golden carrier,
so the linear residual (sum_T\widehat Z_T) is the first falsifiable null;
the cubic residual is the second.  The C718 covariance sum is retained only as
a matched-transfer/distinguishability control because it is universal.

## Shot and state-quality budget

The certificate uses a planning target of ten-percent relative precision with
simultaneous 95-percent coverage for six Bernoulli probabilities.  At one
accepted state per second:

| reading | probability | accepted trials | time |
|---|---:|---:|---:|
| balanced fermion, each protocol | (0.128) | 4,742 | 1.32 h |
| weakest calibrated boson event | (0.00512) | 135,250 | 37.6 h |
| largest chiral branch | (0.00606) | 114,167 | 31.7 h |
| smallest chiral branch | (0.000200) | 3,473,883 | 965 h |

At 100 accepted states/s these become 0.79, 22.5, 19.0, and 579 minutes,
respectively.  These are conditional trial counts; source preparation,
coupling, propagation, and detector loss must be used to convert a laboratory
clock rate into the accepted-state rate.

Statistics are not the dominant blocker.  If preparation noise is modeled as
an arbitrary mixture of weight (1-F), keeping its worst probability bias
below ten percent needs (F\ge0.9872) for the balanced event and
(F\ge0.999980) for the smallest chiral event.  With only a fidelity bound,
the trace-distance worst case is sharper: (F\ge0.999836) and
(F\ge0.9999999996), respectively.  The observed (0.91) three-qutrit GHZ
benchmark is neither the correct antisymmetric state nor adequate evidence
for these thresholds.  A characterized noise model could relax the worst-case
bounds, but then the result would be model-dependent.

## Optimal three/five/ten-cut schedule

Represent the ten balanced cuts by

\[
012,013,014,015,023,024,025,034,035,045.
\]

The six sister words in the certificate have pairwise Hamming distance six.
After Golden membership is known, cuts (012,013,014) are one of 60
three-sign classifiers and identify the projective sister.  For a single
joint certification/identification run, use the five-cycle positions
(012,015,023,034,045): the five magnitudes test Golden extremality and the
five signs identify the sister.  For noisy operation measure all ten and use

\[
 \widehat T=\arg\max_T\langle y,r_T\rangle.
\]

Hard-decision nearest-word decoding corrects any two sign errors.  Soft
matched filtering uses the regular-simplex geometry and is the preferred
laboratory decoder.  No relative sign word distinguishes (C) from (-C);
the coherent port-orientation reference remains necessary.

## Hardware literature refresh

This is a targeted primary-source refresh, not a novelty audit.

1. Matthews et al., *Observing fermionic statistics with photons in arbitrary
   processes* (2013), full article and Methods.  It proves the
   (N)-particle/(N)-copy entangled-state emulator but experimentally
   demonstrates only two photons.  It therefore licenses the architecture,
   not the C719 state preparation.
   https://doi.org/10.1038/srep01539
2. Goyal et al., *Qudit-Teleportation for photons with linear optics* (2014),
   state-preparation Methods.  It proposes a two-beam-splitter projection for
   the totally antisymmetric three-qutrit state and explicitly requires
   coincidence/heralding.  The article does not report that experiment.
   https://doi.org/10.1038/srep04543
3. Hu et al., *Observation of Genuine High-dimensional Multi-partite
   Non-locality in Entangled Photon States* (2025), experimental results.
   It demonstrates three-qutrit GHZ entanglement with fidelity (0.910(6))
   and about (1.1) Hz fourfold coincidences.  The state symmetry is not the
   antisymmetric resource required here.
   https://doi.org/10.1038/s41467-025-59717-y
4. Somhorst et al., *Quantum simulation of thermodynamics in an integrated
   quantum photonic processor* (2023), platform and Methods.  It demonstrates
   a universal 12-mode SiN mesh with three photons, 54--60 percent optical
   transmission, approximately 90-percent SNSPD efficiency, and
   quasi-number resolution.  This closes the mesh/source/detector component,
   not the antisymmetric source.
   https://doi.org/10.1038/s41467-023-38413-9
5. Rahimi-Keshari et al., *Direct characterization of linear-optical
   networks* (2013), full method and six-by-six experiment.  It supplies the
   coherent reference scan used for the bounded precursor.
   https://doi.org/10.1364/OE.21.013450

The web search also located 2025 integrated components with high conditional
fidelities and number resolution, but they do not change the state-preparation
verdict.  No search result was treated as proof of absence; “no experimental
realization located” is bounded by these queries and sources.

## Publication and placement

C719 alone is not a high-impact experimental result and should not be sold as
one.  Combined with C707, C715, and C718, it supports a compact theory/design
paper whose strongest contribution is the exact determinant/permanent
boundary, Golden benchmark, simplex readout, and quantitative identification
of the missing resource.  *Physical Review A* or *Quantum* is realistic for a
polished theory paper; *Physical Review Applied* or an experimental quantum
optics venue becomes realistic only after an antisymmetric-state prototype.

The note fits beside, not inside, the merged Paper III.  Paper III now contains
the ten-line determinant explanation.  A forward reference should be added
only after C765 has a stable preprint identifier, and it should describe the
companion as an application/design-limit note rather than imply a built
device.

## Evidence and replay

The atomic bundle is:

- `notes/2026-08-01-c719-golden-six-mode-demonstrator.py`;
- `notes/2026-08-01-c719-golden-six-mode-demonstrator.json`;
- `notes/2026-08-01-c719-golden-six-mode-demonstrator-replay.py`;
- `notes/2026-08-01-c719-golden-six-mode-demonstrator.sha256`.

Run from the repository root:

```sh
python3 notes/2026-08-01-c719-golden-six-mode-demonstrator.py --check
python3 notes/2026-08-01-c719-golden-six-mode-demonstrator-replay.py
sha256sum -c notes/2026-08-01-c719-golden-six-mode-demonstrator.sha256
```

The generator reconstructs the C718 pivot frame, produces and checks the
15-Givens netlist, derives the exact balanced/chiral probabilities and
planning counts, enumerates the six simplex words, and selects explicit
three-/five-cut schedules.  The independent standard-library replay rebuilds
the network from the serialized angles, recomputes the exact probability and
anomaly identities, and checks the distance-six decoder.

## EJ + Tao closeout

The extra-juice pass asked whether loss was the main experimental obstruction.
It is not: diagonal attenuation and coherent diagonal phase preserve the two
Segre identities algebraically.  The first genuine structural failure is
mesh/copy mismatch, detected by the linear residual.  That gives the
experiment a clean null before the more delicate cubic test.

The Tao-style pass separated three claims that initially looked like one:
probability statistics, coherent sign recovery, and direct many-body phase
measurement.  Current hardware supports the first for bosons and the second
through calibrated transfer tomography.  It does not support the third for
three emulated fermions.  This distinction forces the `NO-GO` verdict and
prevents a proposal from being reported as an achieved quantum demonstration.

Vibe check: the circuit is small and exact, but the state is not.  That is a
publishable design boundary only when stated plainly.
