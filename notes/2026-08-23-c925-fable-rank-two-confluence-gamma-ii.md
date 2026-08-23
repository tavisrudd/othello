# Numerical non-semisimple Gamma-II: the rank-two confluence claim, its proof, and an unconditional cubic dictionary via Sanda--Shamoto

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Closes the mystery-ledger row "the confluence rule for actual quantum
connections (non-semisimple Gamma-II, numerical part)" of
`2026-08-23-c925-fable-marker-is-levelt-exponent.md` §6c to the extent stated
in §5 below, and lands one unconditional upgrade: the categorical reading of
the cubic's marked block is a theorem of Sanda--Shamoto, not a conjecture.

## 1. Sources read

* Sanda--Shamoto, *An analogue of Dubrovin's conjecture*, arXiv:1705.05989
  (Ann. Inst. Fourier version exists; the arXiv v is what was read).  Newly
  cached: key `arXiv:1705.05989`, sha256
  `887c3d6a3ecce52f2b4a06b0b61506886ecefa71aa0ecf13830caadc9aeae299`.
  Read: §§1--2 complete (Stokes filtrations, Stokes data, mutation systems),
  §4.2--4.3 (Serre functor as B-side monodromy, Theorem 4.16), §5
  (Definition 5.2), §6.1, §7 (Theorem 7.9 and its proof skeleton).
* Cotti--Dubrovin--Guzzetti, *Isomonodromy deformations at an irregular
  singularity with coalescing eigenvalues*, arXiv:1706.04808 (Duke 2019).
  Cached `arXiv:1706.04808`, sha256 `a1ec0068…c9110`.  Read: contents, §1
  through Theorem 1.1 and the surrounding discussion; diagonalizability
  hypothesis confirmed at their lines "A0(t) is diagonalisable … at ∆".
* Sabbah, *A short proof of a theorem of Cotti, Dubrovin and Guzzetti*,
  Portugal. Math. (cached `10.4171/PM/2077`, sha256 `eff6be3c…1cbac8`).
  Read: introduction and criterion; used for positioning only.

## 2. What Sanda--Shamoto provide, in lane terms

Over any field \(k\), for a connection germ of exponential type at \(z=0\)
(their Assumption 3.2), the Riemann--Hilbert image is a Stokes-filtered local
system on \(S^1\); at a \((-C_X)\)-generic direction \(\theta_\circ\) it
yields **Stokes data** (Definition 2.3): the total monodromy \((V,T)\),
graded pieces \((V_c,T_c)\) for each eigenvalue \(c\) of \(c_1\star_0\)
(with multiplicity — no semisimplicity anywhere), and triangular
splitting/co-splitting maps.  The Poincaré pairing makes this a **mutation
system** (Definitions 2.29--2.30).  The pivotal identity is their
compatibility condition, stated just above Definition 2.29:

\[ [v,w\rangle = [Tw,v\rangle \quad\text{for all } v,w, \]

with the explicit remark that a non-degenerate pairing **determines** the
monodromy.  In matrices, \([v,w\rangle=v^TGw\) gives \(T=G^{-T}G\).  Two
consequences the lane can consume directly:

* **Rank-one graded pieces are rigid**: \(G\) scalar forces \(T_c=1\).  This
  is the abstract form of "simple sheets of a quantum connection have trivial
  formal monodromy", now a one-line consequence of polarization.
* **Rank-two graded pieces are classified by one number**: in a
  \(\theta_\circ\)-adapted basis the Gram matrix is
  \(\begin{pmatrix}g_+&a\\0&g_-\end{pmatrix}\) (semiorthogonality is axiom
  (b) of Definition 2.30), and
  \[ \operatorname{tr}T_c \;=\; 2-\frac{a^2}{g_+g_-}. \]

On the B side (their §4.2--4.3): for a semiorthogonal component \(A\) of
\(D^b(X)\), Hochschild homology \(HH_\bullet(A)\) carries
\(T_A:=(-1)^{\deg}\circ\varphi_{S_A^{-1}}\), the inverse Serre functor
twisted by the degree sign, and Theorem 4.16 makes
\(\{(HH_\bullet(A_i),T_{A_i})\}\) Stokes data on \((HH_\bullet(X),T_X)\).
Their **Dubrovin-type conjecture** (Definition 5.2) asks for a framed
semiorthogonal decomposition whose B-mutation system matches the quantum
A-mutation system through the Gamma isomorphism
\(\Gamma:HH_\bullet(X)\to H^\bullet(X)\).

**Theorem 7.9 (Sanda--Shamoto).**  Every smooth Fano complete intersection in
projective space of Fano index \(>1\) satisfies the Dubrovin-type
conjecture, with the semiorthogonal decomposition
\(\langle\mathcal Ku,\mathcal O,\dots,\mathcal O(r_X-1)\rangle\): the
eigenvalue-\(0\) graded piece corresponds to
\(\mathcal Ku=\langle\mathcal O,\dots,\mathcal O(r_X-1)\rangle^\perp\).

The cubic threefold is a complete intersection of index two, so **the cubic
is covered**.

## 3. The rank-two claim

Three nested statements; the first two are proved here, the third is gated.

**(R2) Rank-two confluence.**  Let \(B_\varepsilon\), \(\varepsilon\in D\),
be a holomorphic family of rank-two systems
\(z^2Y'=(U(\varepsilon)+zA(\varepsilon,z))Y\) on a fixed disc, such that for
\(\varepsilon\ne0\) the leading term has distinct eigenvalues
\(u_\pm(\varepsilon)\), and at \(\varepsilon=0\) it is a nontrivial Jordan
block whose twisted germ is regular-singular with Levelt exponent class
\(\{e,-e\}\bmod\mathbf Z\).  Then:

1. \(\operatorname{tr}T(\varepsilon)\) is holomorphic in \(\varepsilon\),
   including at the turning point.
2. For \(\varepsilon\ne0\),
   \(\operatorname{tr}T=e^{2\pi i\rho_+}(1+ss')+e^{2\pi i\rho_-}\) where
   \(\rho_\pm\) are the formal exponents and \(s,s'\) the two Stokes
   multipliers of the pair.
3. \(\operatorname{tr}T(0)=e^{2\pi ie}+e^{-2\pi ie}=2\cos2\pi e\).
4. With a flat non-degenerate pairing (the quantum case): \(\rho_\pm=0\),
   \(s=a/g_+\), \(s'=-a/g_-\), so
   \(2-a(\varepsilon)^2/(g_+g_-)\to2\cos2\pi e\); if the family is
   isomonodromic on \(\varepsilon\ne0\) then exactly
   \[ \frac{a^2}{g_+g_-} \;=\; 4\sin^2(\pi e). \]
5. (Numerical Gamma-II input.)  If the split side is the shadow of an
   exceptional pair — \(g_\pm=1\), \(a=\chi(E,F)\in\mathbf Z\) — then
   \(4\sin^2\pi e=\chi(E,F)^2\in\{0,1,2,3,4\}\), so
   \(e\in\{0,\tfrac16,\tfrac14,\tfrac13,\tfrac12\}\), and the **marked**
   class \(e=1/6\) occurs exactly for \(\chi(E,F)=\pm1\).

*Proof.*  (1) The coefficient matrix is holomorphic on the fixed punctured
disc times \(D\); the fundamental solution along \(|z|=r\) and hence the
monodromy matrix depend holomorphically on \(\varepsilon\).  (2) Classical
rank-two Stokes theory (Balser--Jurkat--Lutz; Malgrange): the monodromy is
conjugate to \((\begin{smallmatrix}1&s\\0&1\end{smallmatrix})
(\begin{smallmatrix}1&0\\s'&1\end{smallmatrix})
\operatorname{diag}(e^{2\pi i\rho_+},e^{2\pi i\rho_-})\).  (3) Regular
monodromy \(\exp(2\pi iR)\) with \(R\) of eigenvalues \(\pm e\) (trace holds
also in the resonant Jordan case).  (4) Polarization: the graded rank-one
pieces are polarized, so \(T_\pm=1\), i.e. \(\rho_\pm\in\mathbf Z\); the
Gram computation above gives the trace and the proportionality
\(s'=-(g_+/g_-)s\).  Constancy under isomonodromy plus (1) and (3) give the
limit.  (5) Arithmetic.  \(\square\)

**(FV) Fixed-variety dictionary (no confluence).**  Let \(Z\) satisfy the
exponential-type assumption, let \(c\) be an eigenvalue of \(c_1\star_0\)
whose **even** graded piece \(V_c^{\mathrm{ev}}\) has rank two.  The quantum
connection preserves parity, so the Stokes-filtered local system, its
grading, and its polarization all split even/odd, and
\(\operatorname{tr}T_c^{\mathrm{ev}}=2\cos2\pi e\) for the block's Levelt
class \(\{e,-e\}\).  If \(Z\) satisfies the Dubrovin-type conjecture with
component \(A\) at \(c\), then \(\Gamma\) (which matches parity:
\(HH_k\mapsto\bigoplus H^{q,q+k}\), and \(p+q\equiv p-q\bmod2\)) gives
\[ 2\cos 2\pi e \;=\;
   \operatorname{tr}\bigl(\varphi_{S_A^{-1}}\big|_{HH_0(A)}\bigr)
   \quad\text{when } HH_{\pm2}(A)=0 , \]
and when the Mukai vector identifies \(HH_0(A)\) with
\(K_0^{\mathrm{num}}(A)\otimes\mathbf C\) this is the trace of the inverse
numerical Serre operator \( (G^{-1}G^T)^{-1}=G^{-T}G \) of the Euler form.

**(FV-cubic, unconditional).**  For the cubic threefold \(X=Y_3\),
Sanda--Shamoto Theorem 7.9 supplies the Dubrovin-type conjecture, with
\(A=\mathcal Ku(Y_3)\) at eigenvalue \(0\).  Here \(HH_\bullet(\mathcal
Ku)=(5,2,5)\) in degrees \((-1,0,1)\), \(HH_{\pm2}=0\), \(HH_0=K_0^{\mathrm
num}\otimes\mathbf C\) of rank two with Euler form
\(\begin{pmatrix}-1&-1\\0&-1\end{pmatrix}\)
(Bernardara--Macrì--Mehrotra--Stellari), whose Serre operator has trace
\(1=2\cos(\pi/3)\).  So the identity "marked block monodromy \(=\) numerical
Serre trace of the Kuznetsov component" — the \(V_3\) row of the
Levelt-exponent report's §6b table — **is now a theorem**, and the pleasing
convention check is that Sanda--Shamoto's B-side operator is the *inverse*
Serre functor, matching \(T=G^{-T}G=(G^{-1}G^T)^{-1}\) exactly.  The same
theorem covers every Fano complete intersection of index \(\ge2\).  The
\(V_{14}\), \(V_{12}\), \(V_{10}\) rows (not complete intersections) remain
empirical dictionary confirmations.

**(HR) Higher-rank confluent extraction (gated).**  To read the class of a
merging pair inside a rank-\(n\) quantum connection (Iritani bulk curves,
threefold-centre corrections), one needs a rank-two **cluster factor**
\(B_\varepsilon\) of the full family: a holomorphic family of rank-two
germs whose \(\varepsilon=0\) member is the merged block and whose
\(\varepsilon\ne0\) Stokes pair is the pair's fine Stokes data.  Formal
level: exists, by the uniform cluster-separated Sylvester recursion (the
lane's KKPYY coprime-factor projector is this statement over its coefficient
rings).  Analytic level: **open in general**, and the precise obstruction is
now identified.  The naive coarse Stokes filtration
\(L_{\le C}:=L_{\le u_+}+L_{\le u_-}\) fails to have rank-two graded pieces
on the two slivers of directions, of angular width
\(O(|u_+-u_-|/\delta)\), where an external eigenvalue \(c'\) sits
Re-between \(u_+\) and \(u_-\); across a sliver, the composite of the two
external Stokes factors (at the \((u_+,c')\) and \((u_-,c')\) directions)
feeds a second-order external contribution into the internal \((u_+,u_-)\)
entry.  Any proof must either bound that mediated contribution (it is the
size of the sliver, hence \(o(1)\) as \(\varepsilon\to0\), which suffices
for the limit statement (R2.4) but not for a fixed-\(\varepsilon\) cluster
factor) or work with marked Stokes structures.  Cotti--Dubrovin--Guzzetti
do not cover this: their memoir assumes \(A_0(t)\) diagonalizable through
the coalescence locus, which excludes the Jordan-block limit by hypothesis.

## 4. Positioning against Cotti--Dubrovin--Guzzetti

Their Theorem 1.1 is the **unramified complement** of (R2): eigenvalues
coalesce while the leading term stays diagonalizable, the deformation is
isomonodromic, and the vanishing conditions hold; conclusion, the merging
pair's Stokes entries vanish.  In the trace identity this is the case
\(e=0\): exponents continuous and \(2\cos 2\pi e=2\) force \(ss'=0\), and in
the polarized setting \(s'\propto s\) upgrades that to \(s=s'=0\) — the
trace identity plus polarization *recovers* the CDG vanishing.  Conversely a
nonzero \(ss'\) forces a Jordan block in the limit: "cubic-type Stokes data
cannot merge semisimply".  The cubic class \(ss'=-1\) is the minimal
violation, exactly as the marker predicate demands.

## 5. What this settles and what it leaves

1. **Settled**: the abstract confluence rule of the Levelt report §6c is now
   proved with the polarized refinements (R2.4), and its numerical form
   (R2.5) is exactly the Euler-form list.  The trace dictionary needs no
   choice of lattice, gauge, or orientation — both sides are conjugation
   invariants — so it composes with the \(\Psi\)-invariance reformulation
   with no calibration debt.
2. **Settled, unconditional**: the categorical reading of the cubic's marked
   block (and of every index-\(\ge2\) Fano complete intersection block)
   via Sanda--Shamoto Theorem 7.9.
3. **Open, now sharply stated**: the fixed-\(\varepsilon\) rank-two cluster
   factor inside rank \(n\) (HR above).  This is the entire remaining
   content of "non-semisimple Gamma-II, numerical part" for the lane; the
   limit form needed to *read a merged class* is (R2.4) plus the
   \(o(1)\) sliver bound, strictly weaker than a full cluster factor.
4. **Consequence for H-C**: the second half of H-C ("no marked three-cycle
   in a threefold centre's correction") can be attacked variety by variety
   through (FV) — compute the even graded pieces of the centre's own
   connection and, where a semiorthogonal decomposition is known, compare
   Serre traces — without ever invoking the confluent extraction.  The
   confluent extraction is needed only to *transport* marked classes along
   Iritani bulk curves through eigenvalue collisions between distinct
   summand blocks; on the odd-cohomology carriers this is already handled
   by the loop-conjugacy/HMT argument (§6e of the Levelt report), so (HR)
   is confined to the \(b_3=0\) carrier tail, which the second half of H-C
   subsumes anyway.

## 6. Computational certificate

`notes/cubic-threefolds-tasks/c925-fable-rank-two-confluence-check.py`
(sha256 `eedd07f09b3fde0540b6837bbc457dfb56ebd1bac0bc6a792a3302db1a43fdc2`),
output `c925-fable-rank-two-confluence-check-output.txt`
(sha256 `8c6c64b9d1bda5af3967619b87ec99cd5808882a5607c775596877dc9f3ecaab`).
Replay:

    uv run --with sympy,numpy,scipy python3 \
      notes/cubic-threefolds-tasks/c925-fable-rank-two-confluence-check.py

Three legs.  (1) Exact sympy: the single-valued gauge
\(\operatorname{diag}(1,z)\) carries the \(\varepsilon=0\) model family
(leading \(J_2\), the C924 diagonal residue, the \(-8/81\) second-order
entry) to \(zW'=R^\sharp W\) with \(R^\sharp\) equal to the modified residue
of the audit script `c924-finite-cubic-check.py` — the independent
cross-check — with exponents \(\{-1/6,-5/6\}\) and monodromy trace exactly
\(1\).  (2) Exact sympy: \(\operatorname{tr}(G^{-T}G)=2-a^2/(g_+g_-)\) and
the \(a^2\mapsto e\) list of (R2.5).  (3) scipy DOP853 monodromy of the
family \(U_\varepsilon=(\begin{smallmatrix}0&2\\\varepsilon&0
\end{smallmatrix})\) around \(|z|=1\): trace \(=1.000000000\) at
\(\varepsilon=0\) (validating leg 1 by direct integration) and at every
tested \(\varepsilon\) with \(|\varepsilon|\le0.5\), real and complex.
There is no second implementation of leg 3; leg 1 is its exact
cross-check at \(\varepsilon=0\).

An untracked probe showed the trace is *not* globally constant (at
\(\varepsilon=50\) it is far from \(1\); perturbing the diagonal residue
moves it off \(1\) at all small \(\varepsilon\) but leaves it
\(\varepsilon\)-flat), so the small-\(\varepsilon\) flatness to eleven
digits is a genuine rigidity of the family, stronger than the continuity
the claim needs — see the ledger.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Confluence rule for rank-two families, polarized form, integrality list. | §3 (R2), proof complete; certificate legs 1--3. |
| settled | Cubic dictionary row is unconditional; B-side operator is the inverse Serre functor, matching \(T=G^{-T}G\). | Sanda--Shamoto Theorem 7.9 + BMMS Euler form; §3 (FV-cubic). |
| settled | CDG vanishing is the \(e=0\) row and is recovered trace-level by polarization; their memoir excludes the Jordan limit by hypothesis. | §4; their diagonalizability assumption, checked in the cached text. |
| open, sharpened | Fixed-\(\varepsilon\) rank-two cluster factor inside rank \(n\); sliver-mediated second-order mixing is the identified obstruction. | §3 (HR).  Needed only on \(b_3=0\) carrier tails, which H-C's second half subsumes. |
| observed, unexplained | The model family's monodromy trace is \(\varepsilon\)-flat to \(10^{-11}\) for \(|\varepsilon|\le5\) yet moves at \(\varepsilon=50\); a constant unipotent gauge shows the \(\varepsilon\)-perturbation is equivalent to an eigenvalue splitting \(\pm\sqrt{2\varepsilon}\) plus a first-order residue shear, so all polynomial orders of the trace's \(\varepsilon\)-dependence cancel. | Untracked probe (§6).  Suggests the model is trace-isomonodromic to all orders at the turning point; would follow from an exact isomonodromic normalization of the family — cheap candidate successor calculation. |
| queued | Apply (FV) to the §6f residue list: del Pezzo fibrations over \(\mathbf P^1\) and conic bundles over surfaces with known semiorthogonal decompositions; prediction \(e\in\{0,1/2\}\) unless the component carries cubic-type Prym data. | Card `Next` item 2; the Serre-trace side is now theorem-backed only for complete intersections, so these rows need either their own Dubrovin-type verification or the direct period computation of the rank-one tool. |

No manufactured mysteries: rows four to six are the whole remaining surface.

## Next

`go C925 cubic-threefolds` — highest-EV successor inside the task: run the
(FV) computation on the first Mori--Mukai conic-bundle rows (card `Next`
item 2), now with the Serre-trace prediction pinned by the proved
dictionary; the Lean retype of `ExactCubicPoint` (card `Next` item 3) stays
queued for the guarded window.
