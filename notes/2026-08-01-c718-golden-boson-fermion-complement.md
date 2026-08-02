# C718 — Golden boson--fermion complement

**Lane:** `golden`

**Status:** research complete; no manuscript edit

## Verdict

There is a clean bosonic invariant, but it is not a second signed Segre
coordinate.  The intrinsic bosonic companion of the filled-fermion transfer
is the trace of the transfer on the symmetric cube.  If

\[
 K=Q_-^{\mathsf T}D_xQ_+,
 \qquad H=K^{\mathsf T}K,
\]

then the sum of the all-transferred probabilities over the ten normalized
three-boson input occupations is

\[
 B_{\mathrm{sym}}=\operatorname{tr}(\operatorname{Sym}^3H)=h_3(H),
\]

whereas the filled three-fermion probability is

\[
 F_{\mathrm{ext}}=\operatorname{tr}(\bigwedge^3H)=e_3(H)=\det H.
\]

At every balanced mask, for every one of the six Golden protocols,

\[
 \operatorname{spec}H=\{1/5,4/5,4/5\},\qquad
 B_{\mathrm{sym}}=\frac{313}{125},\qquad
 F_{\mathrm{ext}}=\frac{16}{125},
\]

and

\[
 \boxed{B_{\mathrm{sym}}-F_{\mathrm{ext}}
 =\operatorname{tr}(H)\operatorname{tr}(H^2)=\frac{297}{125}.}
\]

The operational bosonic average is (B_{\mathrm{sym}}/10=313/1250), so
its ratio to the fermionic event is (313/160).

This invariant is necessarily orientation-blind.  More strongly, the bare
permanent of (K) is not a Golden scalar: it depends on the ordered
orthonormal port bases in (V_+) and (V_-).  After a port gauge is frozen,
the permanent does give a useful calibrated coherent discriminator, but it
does not descend to the unmarked Golden operator.  Thus the accepted crown
is both positive and negative:

- the symmetric-cube trace is the permanent-side invariant;
- the oriented Segre-node shadow is specifically exterior/antisymmetric;
- a coherent calibrated permanent can retain the oriented control, while
  any probability-only intrinsic bosonic measurement cannot.

No manuscript was edited.

## 1. Preparation and normalization

Fix one Golden conference matrix (C_T), its eigenspaces (V_{T,+}) and
(V_{T,-}), and ordered orthonormal port frames (Q_{T,+},Q_{T,-}).  The
three input bosons occupy one boson in each (+) port.  For a path filter
(D_x=\operatorname{diag}(x_0,\ldots,x_5)), the postselected one-particle
transfer into the three (-) ports is

\[
 K_T(x)=Q_{T,-}^{\mathsf T}D_xQ_{T,+}.
\]

For output occupation (n=(n_1,n_2,n_3)), (|n|=3), let (K[n]) repeat
row (i) exactly (n_i) times.  The subnormalized bosonic probability is

\[
 P_B(n\mid111)=\frac{|\operatorname{per}K[n]|^2}{n_1!n_2!n_3!}.
\]

The collision-free event is only the one term

\[
 P_B(111\mid111)=|\operatorname{per}K|^2.
\]

The full postselected three-port branch contains all ten occupations and
sums to

\[
 \sum_{|n|=3}P_B(n\mid111)=\operatorname{per}(K^{\mathsf T}K).
\]

This is still input-port-gauge dependent.  The certificate therefore also
contains all 56 output occupations in the complete six-mode output for the
base protocol and all twenty balanced inputs; those probabilities sum to
one.  The six protocols are obtained from the recorded path permutations.
This distinguishes three different objects that must not be conflated:

1. one collision-free permanent event;
2. the ten-event all-in-(V_-) postselected branch;
3. the full 56-event six-mode output distribution.

The basis-free quantity used in the theorem is different again: average
uniformly over the ten normalized input Fock occupations and sum the ten
output occupations.  Its numerator is the Hilbert--Schmidt norm squared of
(\operatorname{Sym}^3K), namely (h_3(H)).

## 2. Why a permanent coordinate is not intrinsic

The Golden data determine (V_+) and (V_-), not ordered orthonormal axes
inside them.  Replacing the frames by (Q_+R_+) and (Q_-R_-), with
(R_\pm\in O(3)), sends

\[
 K\longmapsto R_-^{\mathsf T}KR_+.
\]

The determinant changes only by the two orientation signs.  The permanent
does not.  For the simplest witness, take (K=I_3) and rotate the first two
right ports through an angle (\theta).  The permanent becomes
(\cos(2\theta)), so it moves from one to zero at (\theta=\pi/4), while
all singular values and (|\det K|) stay fixed.

Consequently a six-vector of permanents cannot be defined from the six
unmarked Golden protocols.  Even transporting a base frame by a permutation
representative is not canonical: changing that representative by the
synthematic-total stabilizer produces an internal orthogonal port rotation
and changes the permanent.

This also proves the sharp negative invariant theorem needed here.  Two real
matrices are in the same (O(3)\times O(3)) orbit precisely when they have
the same singular values.  Hence every intrinsic bosonic scalar is a
function of those singular values.  All balanced Golden blocks have the
same spectrum, so every such scalar is blind to both the Segre node and its
orientation.  Under (SO(3)\times SO(3)), the determinant sign survives as
the extra orbit label; this is exactly the antisymmetric datum carried by
(Z_T).

## 3. Exact calibrated permanent

For a reproducible physical port convention, the evidence freezes the
**pivot-frame gauge**

\[
 Q_+=\operatorname{GS}(P_+e_0,P_+e_1,P_+e_2),\qquad
 Q_-=\operatorname{GS}(P_-e_0,P_-e_1,P_-e_2),
\]

using positive square roots.  The exact matrices are stored in the JSON
certificate.  In this gauge

\[
 \operatorname{per}K_{\rm base}(x)=\frac{Y(x)}{100\sqrt5},
\]

where (Y\in\mathbf Z[x_0,\ldots,x_5]) is the recorded 44-term cubic.  The
same expansion independently verifies

\[
 \det K_{\rm base}(x)=\pm\frac{Z_{\rm base}(x)}{10\sqrt5}.
\]

For the six frozen lexicographic transports (p_T),

\[
 Y_T(x)=Y(x_{p_T(0)},\ldots,x_{p_T(5)}).
\]

For odd (p_T), the two Golden eigenspaces exchange; transposition leaves
the permanent unchanged.  This formula specializes the exact permanent to
all six protocols while retaining the explicit warning that a different
stabilizer representative changes the physical port gauge.

## 4. Balanced-mask census

The twenty coherent calibrated amplitude vectors (Y_T(x)) are all
distinct, so coherent access to their signs recovers the oriented balanced
control in this gauge.  Complementing the control negates the entire vector.
Probability readout squares it and loses orientation.

The collision-free probabilities across the six protocols have exactly two
multisets:

\[
 \begin{array}{c|c|c}
 \text{balanced masks}&\{|Y_T|\}_{T=1}^6&
   \{P_B(111\mid111)\}_{T=1}^6\\ \hline
 8&24^6&(36/3125)^6\\
 12&16^2,32^4&(16/3125)^2,(64/3125)^4.
 \end{array}
\]

The fermionic probability is (16/125=400/3125) in every coordinate.
Thus the boson/fermion collision-free ratios are either

\[
 (9/100)^6
 \quad\text{or}\quad
 (1/25)^2,(4/25)^4.
\]

There are twenty coherent amplitude vectors but only four labelled
probability vectors.  The latter pair antipodal controls and do not recover
the ten projective Segre nodes.  The ten-event postselected distributions
and the 56-event full distributions each have six exact spectral classes of
sizes (2,2,4,4,4,4) in the pivot gauge.  Their full algebraic values are in
the certificate; they are deliberately not promoted to invariants.
The fixed-input postselected total
(\operatorname{per}(K^{\mathsf T}K)) already has five values:

\[
 \frac{128\pm16\sqrt5}{625}\ (2\text{ masks each}),\qquad
 \frac{139\pm9\sqrt5}{625}\ (4\text{ masks each}),\qquad
 \frac{162}{625}\ (8\text{ masks}).
\]

This is the exact dependence of the full three-port bosonic branch on the
oriented balanced control in the frozen gauge.  Complementary masks exchange
the conjugate pairs or remain at (162/625); none of these totals descends
through a change of input port axes.

## 5. Jabbour--Cerf specialization

For a real (3\times3) block (K), the collision-free complementarity
identity specializes to

\[
 J_0-J_1+J_2-J_3=0,
\]

where

\[
 \begin{aligned}
 J_0&=|\operatorname{per}K|^2,\\
 J_1&=\sum_{|I|=|J|=1}|\det K_{I,J}|^2
       |\operatorname{per}K_{I^c,J^c}|^2,\\
 J_2&=\sum_{|I|=|J|=2}|\det K_{I,J}|^2
       |K_{I^c,J^c}|^2,\\
 J_3&=|\det K|^2.
 \end{aligned}
\]

At the balanced base blocks the exact layer triples, in units of (1/3125),
are

\[
 (J_0,J_1,J_2,J_3)
 \in\{(36,172,536,400),
       (16,432,816,400),
       (64,360,696,400)\}.
\]

Each has alternating sum zero.  Path transport supplies the six Golden
protocols.  The identity is universal in (K), so it is a consistency
check, not a Golden certificate by itself.

## 6. Human proof of the symmetric/exterior invariant

Let the eigenvalues of (H=K^{\mathsf T}K) be
(\lambda_1,\lambda_2,\lambda_3), and write
(p_r=\sum_i\lambda_i^r).  The normalized bosonic Fock basis is an
orthonormal basis of (\operatorname{Sym}^3V_+).  Summing the probability
of landing in (\operatorname{Sym}^3V_-) over that basis gives

\[
 \|\operatorname{Sym}^3K\|_{\rm HS}^2
 =\operatorname{tr}(\operatorname{Sym}^3H)
 =h_3(\lambda).
\]

The filled fermion state spans (\bigwedge^3V_+), so its transfer
probability is

\[
 \|\bigwedge^3K\|^2=e_3(\lambda)=\det H.
\]

Newton's formulas give

\[
 h_3=\frac{p_1^3+3p_1p_2+2p_3}{6},\qquad
 e_3=\frac{p_1^3-3p_1p_2+2p_3}{6}.
\]

Subtracting proves (h_3-e_3=p_1p_2) for every real or complex
(3\times3) transfer block.  At a balanced Golden mask C707 gives

\[
 p_1=9/5,\qquad p_2=33/25,
\]

and its squared singular spectrum gives (p_3=129/125).  Direct
substitution yields

\[
 h_3=313/125,\quad e_3=16/125,\quad h_3-e_3=297/125.
\]

This proof is independent of the permanent census and of the pivot gauge.

## 7. EJ + Tao closeout: the missing exchange sector

The acceptance gate leaves one free representation-theoretic completion.
The generating functions for complete and elementary symmetric powers obey

\[
 \left(\sum_{r\ge0}h_rt^r\right)
 \left(\sum_{r\ge0}(-1)^re_rt^r\right)=1.
\]

Its degree-three part is the basis-free Muir-type complementarity

\[
 h_3-e_1h_2+e_2h_1-e_3=0.
\]

At a balanced Golden block its four layers are

\[
 \frac1{125}(313,513,216,16),
\]

whose alternating sum vanishes.  This is the trace-level companion of the
occupation-resolved Jabbour--Cerf identity; it is classical symmetric-function
machinery, not a novelty claim.

Tao's natural missing question is where the standard (S_3)-exchange type
went.  Schur--Weyl decomposition gives

\[
 V^{\otimes3}=\operatorname{Sym}^3V
 \oplus 2S_{(2,1)}V\oplus\bigwedge^3V.
\]

The remaining trace is

\[
 s_{(2,1)}(H)=\frac{p_1^3-p_3}{3}=\frac85,
\]

and the complete checksum is

\[
 h_3+2s_{(2,1)}+e_3=p_1^3=\frac{729}{125}.
\]

Thus no exchange sector is missing: the bosonic, two standard, and fermionic
traces close exactly.  This also explains why searching for another signed
scalar on the permanent side was misdirected; the extra information lives in
the mixed-symmetry sector, while orientation remains exterior.

## 8. Experimental discriminator

The minimal basis-free Golden spectral check uses three aggregate numbers:

1. a one-particle estimate of (p_1=\operatorname{tr}H);
2. the filled three-fermion event (e_3=\det H);
3. the uniformly averaged ten-input bosonic transfer (h_3/10).

Given (p_1=9/5), the boson--fermion difference recovers
(p_2=(h_3-e_3)/p_1=33/25), while (e_3=16/125).  These are the three
elementary spectral data of (H), and their characteristic polynomial is

\[
 (t-1/5)(t-4/5)^2.
\]

Thus the three aggregate readings certify the balanced Golden singular
spectrum without choosing port axes.  Two aggregate readings cannot in
general recover a three-eigenvalue spectrum; the one-particle trace is the
minimal extra scalar unless it is independently calibrated.

For a cheaper calibrated control, use one balanced mask and the six
collision-free bosonic/fermionic ratios above.  It rejects a device that
misses both allowed pivot-gauge patterns, but it is a port-calibration test,
not an intrinsic theorem.

Partial distinguishability or unequal bosonic and fermionic transfer
matrices can mimic failure.  The robust mismatch control is therefore the
general covariance sum rule

\[
 C_B+C_F=2C_{\rm classical}
\]

for matched interferometers and a common distinguishability Gram matrix.
A violation rejects that shared-mode model.  Satisfaction alone does not
certify the Golden mixer because the identity is universal.

## 9. Bounded literature positioning

This was a positioning check, not a novelty audit, and makes no priority or
absence claim.  Zero sources were read at full text; three primary sources
were read partially at the sections stated here.

1. Michael G. Jabbour and Nicolas J. Cerf,
   *Boson--fermion complementarity in a linear interferometer: an identity
   relating the determinant and permanent of a matrix*.
   **Read depth:** partial, cached arXiv v2, Sections II--V and the statements
   and specializations of Theorems 1--2 and Corollary 1.  It owns the
   universal convolution and squared-minor permanent--determinant identity,
   including the three-particle collision-free formula used above.  Cache
   key `arXiv:2312.17709`, SHA-256
   `57e299c41729d839449d74522d73251702314e928b883645cdf50fe79c64fa45`.

2. Malte C. Tichy and Klaus Mølmer,
   *Extending bosons and fermions beyond pairwise exchange symmetry*.
   **Read depth:** partial, cached arXiv version, introduction and the
   many-body scalar-product derivation around Eqs. (22)--(27).  It supplies
   the standard permanent/determinant/immanant interpretation of symmetric,
   antisymmetric and other exchange sectors and the Gram-permanent norm
   mechanism.  Cache key `arXiv:1702.03528`, SHA-256
   `dbeb5fda77b2c3b073477e2e81e155e2b642376aa86cd66bfea3b619e51cd2ec`.

3. Marco Robbio, Michael G. Jabbour, and Nicolas J. Cerf,
   *Complementarity between bosonic and fermionic many-body interferences
   with partially distinguishable particles*.
   **Read depth:** partial, cached arXiv v1, introduction, Theorem 1 in
   Section III, and the covariance result in Section IV.  It extends the
   complementarity to a common distinguishability Gram matrix and owns the
   covariance sum rule used as the mismatch control.  Cache key
   `arXiv:2604.23316`, SHA-256
   `d8ce6c8a32d3c4eef3bd6f98431acf33dda8c87b9ab35dd7e5e19bb4e6d3fafc`.

The bounded web queries were:

- `Jabbour Cerf boson fermion complementarity determinant permanent identity 3x3`;
- `multiparticle interference immanants partial distinguishability bosons matrix permanent`;
- `bosonic transition probabilities symmetric power trace linear optics`;
- `boson fermion complementarity permanent determinant immanant`.

The search establishes attribution, not novelty.  The general
permanent--determinant complementarity, Gram-permanent norm, immanant sector,
and partial-distinguishability covariance control are pre-existing.  The
Golden values and gauge-obstruction synthesis are retained only as C718's
task-local specialization.  MathSciNet and Google Scholar were not covered;
no `first` or `no predecessor` wording is licensed.

## 10. Evidence and replay

The atomic evidence bundle is:

- `notes/2026-08-01-c718-golden-boson-fermion-complement.py`;
- `notes/2026-08-01-c718-golden-boson-fermion-complement.json`;
- `notes/2026-08-01-c718-golden-boson-fermion-complement-replay.py`;
- `notes/2026-08-01-c718-golden-boson-fermion-complement.sha256`;
- this report.

Exact generation/check command from the repository root:

```bash
nix shell --impure --expr 'let pkgs = import (builtins.getFlake "nixpkgs") {}; in pkgs.python3.withPackages (ps: [ps.sympy])' --command python3 notes/2026-08-01-c718-golden-boson-fermion-complement.py --check
```

Independent standard-library replay:

```bash
python3 notes/2026-08-01-c718-golden-boson-fermion-complement-replay.py
```

The generator uses SymPy 1.14.0 and deterministic canonical enumeration.
The JSON records the exact pivot frames, all 44 permanent coefficients, all
twenty balanced records, the six transport representatives, all ten
postselected and 56 full-output probabilities for the base protocol, the
Jabbour--Cerf layers, the invariant moments, and its trust boundary.  The
independent replay uses only integer polynomial evaluation and rational
arithmetic; it rederives the balanced amplitude/probability census and the
symmetric/exterior trace values without SymPy.

## Mystery ledger

- **Settled — why the determinant sees an oriented node but the permanent
  does not descend.**  The exact obstruction is the internal
  (O(3)\times O(3)) port gauge; only the (SO\times SO) determinant sign
  survives beyond singular values.
- **Settled — whether a bosonic invariant exists.**  The symmetric-cube
  trace is canonical and gives (313/125), with the exact complement
  (297/125).
- **Settled by EJ + Tao — whether a third exchange sector was being
  suppressed.**  The standard (S_{(2,1)}) trace is (8/5), occurs twice,
  and closes the full tensor-cube checksum (729/125).
- **Settled — whether balanced permanent probabilities restore the lost
  signs.**  In a frozen gauge coherent amplitudes do, but probabilities have
  only four labelled vectors and are antipode-blind; intrinsically all
  balanced values depend only on the common singular spectrum.
- **Open only for C719 — platform cost of the ten-input symmetric-cube
  average.**  The mathematics fixes the minimal aggregate data, but source
  brightness, detector number resolution, and covariance-estimation cost
  are platform-specific.  C719 owns that feasibility budget.

## Close

C718 supplies the literal permanent-side theorem required by C719, but with
the correct boundary: the new invariant is the symmetric-cube trace, while
the collision-free permanent is a calibrated port observable.  The result
strengthens rather than mirrors the fermionic story: antisymmetry owns the
orientation, symmetry owns a rational spectral checksum.
