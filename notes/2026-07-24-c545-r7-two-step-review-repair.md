# C545 R7 two-step review repair

**Lane:** `reed-solomon`  
**Date:** 2026-07-24  
**Status:** repaired; final referee grade A (93)

## Result

The retained R5--R7 manuscript now answers the second correctness review without
using a new finite certificate.  The final referee recommends banking the
uniform component upgrade recorded below and stopping mathematical expansion.

- The threshold function is printed as
  \[
  \mathcal H_\kappa(g,\delta)
   =1+\left\lfloor
      \left(g+\sqrt{g^2+\delta-\kappa}\right)^2
     \right\rfloor .
  \]
  Thus \(\mathcal H_1(1,19)=29\), and the manuscript also checks
  \(30-2\sqrt{29}>19\).
- The R6 lower fixed-gcd equality \(\lambda_0=r\) is the collision-divisor
  condition.  The manuscript now states the general equivalence once: every
  section through the marker is double if and only if the contracted system
  has that marker as fixed root if and only if the marker is ramified.
- The R7 trivial-gcd branch now contains a complete second-marker package.
  Its outer unavailable scheme has degree at most
  \[
  1+3+4+6+2=16:
  \]
  old-marker equality, lower secant, cyclic/wild carrier, self-collision, and
  fixed-old-marker gcd.  Outside it, the bottom pencil is handled either by
  the pointed linear-gcd graph with deletion at most \(12\), or by the
  geometrically integral \(S_3\) curve with
  \((g,\delta,\kappa)=(1,25,1)\).  The latter gives the binding first
  prime-power threshold \(37\).
- The R7 exact-gcd-one case \(x=r\) is identified with the marked
  self-collision divisor instead of being discarded as a genericity
  assumption.
- The manuscript defines \(E_f\) and \(\tau_5(f)\), states and derives the R7
  persistent count, prints one canonical representative per R7 orbit-size
  block with the full-list locator, and states the three empty prime-power
  intervals.

Both manuscript drivers build without final LaTeX warnings.  After the
uniform-theorem and exposition pass, the canonical and IEEE review builds have
28 and 22 pages.

The next independent review confirmed the displayed floor byte-for-byte,
recomputed the degree-\(16\) two-marker package and its fixed-factor
exclusion, checked the marker--gcd equivalence, and independently reproduced
sample \(E_f\) and \(\tau_5\) entries.  It therefore closes the cold-review
gate.  Its six residual editorial findings are also repaired in source:
the R6 deletion bound is nineteen; the \(q=8\) R7 profile explicitly removes
the central nucleus singleton; Proposition 6.10 cites both lower exclusions;
its lower-net variable is no longer overloaded; the quadratic-gcd
catalecticant clause is explicit; and the R7 \(x=r\) branch lies in the
collision divisor by the shared marker--ramification lemma.  A final referee check caught one remaining
presentation defect inside Proposition 6.10: its conclusion
\(\lambda_0\notin\{x,s\}\) was still bare.  The invocation now points
locally to both preceding ingredients---the fixed-\(x\) minors and the
pointed self-collision exclusion for \(s\).

## Uniform theorem and exposition pass

The three transverse thresholds are now stated as one theorem.  After
\(r-5\) contractions the bottom object is always the R5 genus-one
off-diagonal curve.  Its base deletion is \(13\), and each retained
marker contributes at most \(6\), so
\[
 \delta_r=6r-17,\qquad
 Q_r=6r-15+\lfloor2\sqrt{6r-17}\rfloor .
\]
At an intermediate redundancy \(j\), with \(s=r-j\) old markers, the
bottom stage has
\[
 d_6\leq3+4+6+3(r-6)=3r-5.
\]
At every \(j\geq7\), the modular pullback is linear and the collision
series is separable, so
\[
 d_j\leq3+1+(2j-6)+3(r-j)=3r-j-2<3r-5.
\]
Hence \(q+1>d_j\) is automatic whenever \(q\geq Q_r\).  The theorem
assumes only the stable-component assertions \(\mathrm{SC}(j)\),
\(6\leq j\leq r\); it does not assert them in arbitrary degree.

The same pass factors the two marker-equals-fixed-root computations
through one marker--ramification lemma, expands the syndrome/recurrence
dictionary, and displays the \(q=19\) net's six members
\[
 U(T^3-uU^3),\qquad
 u\in\{1,7,8,11,12,18\}.
\]
They all contain infinity, whereas the member with \(u=1\) avoids the
marker \(0\).  This exhibits the pointed obstruction directly.

To pay for the theorem, the manuscript removes the duplicate overview
figure, the referee-directed roadmap, the online-complexity defense,
the detailed Lean inventory, the threshold table, and the R8/R9
preview.  The proof example at \(q=29\) remains.

## EJ + TT closeout

The closeout audit separated the two parameter levels explicitly.  Every
second-marker failure is now in the degree-16 outer scheme; every remaining
failure on the bottom curve is in the stated graph or \(S_3\) deletion.  The
fixed-old-marker minor locus cannot be the whole parameter line: otherwise
every member of the original trivial-gcd net would vanish at the old marker.
This closes the only potentially hidden contained case introduced by the
repair.

The numerical cutoff has slack at the outer level:
\(16<q+1\) already far below \(q=37\).  The binding condition is the bottom
\(S_3\) point count \(q+1-2\sqrt q>25\), so the repair does not raise the
geometric threshold or open a new finite-field interval.

The extra-juice pass also tested the quantifiers in the conditional uniform
theorem.  The chain does not require an unstated inverse-image property for the
persistent or modular loci.  At stage \(j\), the current contraction was chosen
outside \(\mathcal P_j\cup\mathcal M_j\); the corresponding
\(\mathrm{CC}(j-1,1)\) assertion therefore rules out a wholly bad next polar
line, after which the finite parameter scheme supplies the next marker.  The
manuscript now says this before the uniform theorem.

The final review first isolated the degree-four term correctly: it belongs only
to the R5 cyclic/wild carrier.  A further structural pass then removed the
temporary arbitrary modular-degree hypothesis.  Every modular nucleus is
linear, and the polar map is linear, so a transverse modular pullback has
degree at most one.  Meanwhile an inseparable
\(g^{j-4}_{j-2}\) forces
\[
 p\mid(j-2),\qquad p(j-4)\leq j-2.
\]
The only solutions are \((j,p)=(5,3),(6,2)\), exactly the two special
arguments already printed; collision is separable for \(j\geq7\).  Thus the
sharp uniform parameter bound is again \(3r-5\), attained at the bottom
stage.  The independently verified degree-\(13\) and degree-\(16\) packages
and both headline classifications are unchanged.

Four alternatives in the contained-component assertion are therefore uniform.
The remaining assertion, denoted \(\mathrm{SC}(j)\), is that no additional
contained component occurs outside the persistent and modular loci.  This is
not circular: \(\mathrm{SC}(j)\) is scheme-theoretic and contains no
field-size conclusion, while the uniform theorem converts its validity through
level \(r\) into the classification for \(q\geq Q_r\).  R6 and R7 prove their
instances unconditionally.

The final extra-juice pass banks the immediate large-characteristic corollary.
If \(\mathrm{SC}(j)\) holds through \(r\), \(q\geq Q_r\), and
\(\operatorname{char}\F_q>r-1\), Lucas makes \(\mathcal M_r\) empty;
the split-free list is exactly the persistent tangent and
conjugate-secant families.  Under the separate radius gate this is also the
deep-hole list; in particular, the conclusion applies over every prime field
meeting \(q\geq Q_r\).  This is a sharpening of the conditional theorem, not
progress on the unidentified cyclic-type contained residue.

## Editorial truth table

| Review condition | Printed resolution | Budget or census effect |
|---|---|---|
| R6 marked deletion is \(13+6\) | Proposition 6.4(iii) says nineteen | none; threshold remains \(29\) |
| The \(q=8\) R7 profile omits one known orbit | The theorem says the central nucleus singleton is removed before printing the additional profile | none; census total is unchanged |
| R7 uses the lower secant and cyclic/wild exclusions | Proposition 6.10 cites Propositions 6.3 and 6.4/6.5 at the two uses | none |
| The lower-net letter collides with the ambient syndrome \(f\) | Proposition 6.10 uses \(h\) for the lower syndrome and \(g\) for a member | none |
| A contraction has quadratic gcd | The rank-at-most-two three-row catalecticant clause points to the transverse degree-three and contained alternatives | none |
| The R7 exact-gcd-one root equals the first marker \(r\) | The shared marker--ramification lemma places the branch inside the existing degree-eight collision divisor | no new deletion term |
| The Proposition 6.10 lower gcd equals \(x\) or \(s\) | The invocation now cites the fixed-\(x\) minors immediately above and Proposition 6.4's pointed self-collision exclusion for \(s\) | no new deletion term |

## Mystery ledger

| Feature | Status | Evidence or remaining gate |
|---|---|---|
| Why the review obtained \(29.718\) for \(\mathcal H_1(1,19)\) | settled | That is the unfloored real expression.  The theorem uses one plus its floor, equal to \(29\); the revised display and direct \(q=29\) inequality remove the ambiguity. |
| Whether the R7 second step meets a cyclic pencil with no split witness | settled | The cyclic/wild pullback is an outer second-marker exclusion of degree at most four. |
| Whether a lower fixed factor can equal an old or new marker | settled | Equality with the new marker is in the pointed collision divisor; equality with the old marker is the nonzero degree-at-most-two evaluation-minor locus. |
| Whether the repaired R7 proof is independently referee-clear | settled | The next reader reconstructed the degree-\(16\) package and independently checked the fixed-factor exclusion, marker--gcd equivalence, threshold arithmetic, and sample census invariants. |
| Why the transverse thresholds differ by \(7,8,\ldots\) | settled | They are evaluations of \(Q_r=6r-15+\lfloor2\sqrt{6r-17}\rfloor\); the point-count scale is linear. |
| Whether the uniform theorem is circular with the stable-component conjecture | settled | No.  \(\mathrm{SC}(j)\) has no field-size conclusion; it excludes additional scheme-theoretic contained components.  The theorem supplies the arithmetic threshold \(Q_r\). |
| Whether \(\mathrm{SC}(j)\) holds in arbitrary degree | open | This is the remaining component problem.  Cyclic-type carriers are not identified uniformly; no arbitrary-level proof is claimed. |
| Whether the uniform theorem assumes inverse-image stability of the declared loci | settled | No.  Each current contraction is selected outside the next declared bad locus; \(\mathrm{SC}(j)\) excludes a wholly bad polar line and permits another transverse choice.  The manuscript prints this induction invariant. |
| Which numerical inequality can bind at arbitrary redundancy | settled | Linear modular pullbacks and uniform collision separability give \(d_j\leq3r-5<Q_r\).  Only the bottom point count binds. |
| When the modular locus vanishes | settled sharpening | If \(p>r-1\), Lucas' theorem leaves no nucleus coordinate, hence \(\mathcal M_r=\varnothing\).  The R5 cyclic carrier is not modular and survives this observation. |
| What the uniform theorem says in large characteristic | settled | Under \(\mathrm{SC}(6),\ldots,\mathrm{SC}(r)\), \(p>r-1\), and \(q\geq Q_r\), only the persistent tangent and conjugate-secant families remain; the radius gate promotes this to the deep-hole list. |
| Whether marker clustering lowers \(\delta_r\) | rejected | At most three markers can share a fiber, and the same parameter freedom must avoid a bad scheme of degree on the order of \(3r\); clustering cannot spend that freedom a second time. |
| Why the last sporadic fields decrease \(19,13,11\) while the point-count gates increase \(23,29,37\) | open | The tables establish the trend through R7.  Whether sufficiently high redundancy has no sporadic fields is a sharper component/arithmetic question, not answered here. |
| Why \(\langle1,t^3,t^4\rangle\) is pointed-bad specifically at \(q=19\) | open | The six split members and their common infinity root are exact, but the intrinsic branch-divisor explanation remains the separately recorded C509 exceptional-cover question. |
| External certificate and release packaging | separately owned | No certificate, replay, manifest, or release identifier was changed in this repair. |
