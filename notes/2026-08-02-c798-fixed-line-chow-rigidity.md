# C798 — fixed-line ambiguity and Chow rigidity

## Outcome

C798 is positive, but in a cleaner form than the original eleven-orbit
target. For
\[
(q,K)=(7,S_4),(11,A_5),
\]
the \(K\)-fixed locus in the ambient conic fiber is an affine line over
\(\mathbf F_q\). Its rational points give \(q\) distinct \(G\)-orbits with
stabilizer \(K\). The secant-product Chow locus meets the line only at the
matching point.

More importantly, no orbit table is needed to disprove carrier-free
quadratic-trade classification. Translation along the fixed line changes
only the outer radial sheet constant. There is one coalescence parameter.
At every other parameter the existing Radical--Hadamard theorem applies
unchanged. Hence \(q-2\) nonmatching orbits have the same exact
one-dimensional, two-valued sheet-sign trade as the matching orbit.

This is the Paper II priority-judo theorem:

- the general Schur-square/Gorenstein mechanism is credited as background;
- the exact \(B_3/H_3\) matching-orbit classification remains intact;
- the matching-carrier hypothesis is proved sharp rather than merely
  retained defensively; and
- complete reducibility, equivalently membership in the secant-product
  Chow locus, is the faithful refinement that selects the matching
  placement.

## Structural proof

Let \(m=(q+1)/2\), \(d=m-2\), and let \(\mathcal A_T\) be the affine fiber
of degree-\(m\) forms with the prescribed restriction to the marked conic.
Its translation space is \(QR_d\).

1. The reference secant product \(P_{M_T}\) is \(K\)-fixed. For \(B_3\),
   \(R_2^{S_4}=\mathbf F_7Q\). For \(H_3\), the quartic character has
   values \(15,3,0,0,0\) on the classes of orders \(1,2,3,5,5\), so
   \[
   \dim R_4^{A_5}=(15+15\cdot3)/60=1,
   \qquad R_4^{A_5}=\mathbf F_{11}Q^2.
   \]
   Thus
   \[
   \mathcal A_T^K=P_{M_T}+\mathbf F_qQ^{d/2+1}.
   \]

2. The subgroup proof already in Paper II gives \(N_G(K)=K\). No point on
   the line is \(G^+\)-fixed, because its radial difference from
   \(P_{M_T}\) is \(G^+\)-fixed. Maximality of \(K<G^+\) therefore makes
   every stabilizer exactly \(K\); self-normalization makes the \(q\)
   points pairwise nonconjugate.

3. A completely reducible point on the line pairs the \(q+1\) marked
   conic points. Unique factorization makes that matching \(K\)-invariant.
   The invariant matching is unique: its two-point block stabilizer is
   \(N_{S_4}(C_3)=S_3\) for \(q=7\), and
   \(N_{A_5}(C_5)=D_{10}\) for \(q=11\).

4. In quotient coordinates write \(x_t=x_0+tr\), with \(r\) radial.
   Relative to the moving base point, the \(G^+\)-sheet is unchanged and
   the outer sheet is translated by \(-2tr\). The top configurations and
   both second moments are unchanged; the two radial constants are
   \(0\) and \(c-2t\). For \(t\ne c/2\), Radical--Hadamard gives the exact
   sheet-sign kernel. The matching point is \(t=0\), with \(c\ne0\).
   Removing the matching and coalescence parameters leaves \(q-2\)
   structural nonmatching counterexamples.

The coalescence point is deliberately non-load-bearing. Its square rank is
not needed for the theorem and remains outside the manuscript proof spine.

## Exact boundary census

The exact \(q=11\) bundle reconstructs the affine action from all 10,395
matchings, solves the \(A_5\)-fixed equations, and checks:

- fixed locus dimension one with 11 rational points;
- 11 distinct size-22 orbits;
- affine Schur-square rank 21 and unique \(11+11\) sheet-sign trade for
  every point, including the coalescence point;
- exactly one orbit in the matching image;
- affine ranks ten times 11 and once 10;
- cubic catalecticant ranks ten times 10 and once 9; and
- 11 distinct projective signed-cubic hashes and 11 distinct quartic
  hashes.

These data explain the exceptional point and cross-check the theorem, but
none is a premise of the manuscript result.

Reproduction:

    python3 notes/2026-08-02-c798-h3-fixed-line.py --check
    sha256sum -c notes/2026-08-02-c798-h3-fixed-line.sha256

The script has 9,968 bytes and the canonical JSON has 10,147 bytes.

## Bounded novelty check

On 2026-08-02, four exact/near-exact searches combined the distinctive
terms PGL(2,q), conic matching products, \(S_4/A_5\), fixed affine line,
quadratic trade, and Chow locus. They found neighboring work on general
Chow and secant varieties and on the association schemes of
\(\operatorname{PGL}_2(q)\) acting on conic secants, but no source stating
this exceptional fixed-line ambiguity, the unique matching-Chow
intersection, or the \(q-2\) carrier-free exact-trade family. This is a
bounded negative, not a universal priority guarantee.

Relevant neighbors:

- https://arxiv.org/abs/1602.04275
- https://arxiv.org/abs/2005.12436
- https://arxiv.org/abs/math/0503573

## Manuscript disposition

The authoritative Paper II source now contains Theorem
thm:fixed-line-chow-rigidity, its structural proof, the sharp carrier
boundary in the abstract and principal theorem, and an explicit
non-load-bearing coalescence remark. The verification table and trust
manifest classify the theorem as conceptual/classical-input with no finite
evidence bundle.

The standalone mirror remains frozen under the existing Paper II handoff.
C801 is queued to formalize the reusable radial-translation and finite-line
count after this human statement is frozen; it must not encode an
eleven-orbit table.

## Extra-juice and Tao closeout

The closeout pass found one free strengthening and two proof-boundary
repairs, all adopted. The theorem now intersects the fixed line with the
full Chow locus of completely reducible forms, not merely a predeclared
finite set of marked-secant products: restriction to the conic and
squarefreeness force every linear factor to be a marked secant. The proof
also states why character averaging is valid in the two tame
characteristics and why radial translation preserves both first and second
moments. These remove the most likely referee seams without adding a
coordinate calculation.

The tempting stronger claim that the signed cubic itself canonically picks
the matching point was not adopted. The exact census separates all eleven
projective cubic lines, but supplies no intrinsic reason to distinguish the
matching value from the other ten. Complete reducibility is therefore the
current sharp faithful refinement.

## Mystery ledger

- **Settled — why an affine line appears.** It is exactly the radial
  invariant line \(R_d^K\); this is proved by tame character averaging.
- **Settled — why almost every point keeps the unique trade.** Moving on
  the line changes only one radial sheet constant, so the existing
  Radical--Hadamard proof survives until the unique coalescence value.
- **Settled — why the matching point is unique.** Full Chow membership
  forces a \(K\)-invariant endpoint pairing, and the relevant
  \(S_3/D_{10}\) block stabilizer is unique.
- **Open but non-load-bearing — why the coalescence point still has
  Schur-square corank one despite losing affine rank.** The exact bundles
  verify this at \(q=7,11\), but the structural explanation is not needed
  by Paper II. It belongs to C801 only if a reusable proof emerges without
  an orbit table.
- **Open and discovery-grade — what geometric curve is traced by the
  projective signed cubics and quartics along the fixed line.** Exact hashes
  show injectivity on rational points, but no canonical matching selector
  follows. This is not queued because it has lower expected value than the
  formal radial-translation closure.
