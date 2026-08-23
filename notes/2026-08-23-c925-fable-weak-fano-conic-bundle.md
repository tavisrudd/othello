# Correction and construction: class (a) over P^2 is not empty — an explicit weak-Fano minimal conic bundle with cubic discriminant and b3=0

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

## 1. Correction to the b3-formula note

`2026-08-23-c925-fable-conic-bundle-b3-formula.md` §2.2 claimed class (a)
over \(\mathbf P^2\) is empty because \(b_3=0\) forces \(d=3\) "i.e. the
MM 2-24 family by the classification".  The formula and the degree
consequence stand; the last step overreached: the Mori--Mukai
classification covers **Fano** threefolds only, and a relatively minimal
conic bundle over \(\mathbf P^2\) with cubic discriminant need not be
Fano.  Section 2 constructs a non-Fano one.  The corrected statement:

> Class (a) over \(\mathbf P^2\) consists precisely of the relatively
> minimal conic bundles with cubic discriminant that are **not** Fano;
> the Fano ones are the closed MM 2-24 family.

## 2. The construction

Let \(E=\mathcal O\oplus\mathcal O\oplus\mathcal O(-3)\) on
\(\mathbf P^2\), \(\pi:\mathbf P(E)\to\mathbf P^2\), \(\xi\) the relative
\(\mathcal O(1)\), \(h\) the hyperplane class.  Take
\(X\in|2\xi+3h|\).  A section of \(2\xi+3h\) is a quadratic form on \(E\)
with symmetric matrix
\[
  \begin{pmatrix}A&B&c\\B&C&d\\c&d&0\end{pmatrix},
\]
\(A,B,C\in H^0(\mathcal O(3))\) cubics and \(c,d\in\mathbf C\) constants
— the \((2,2)\) entry lies in \(H^0(\mathcal O(-3))=0\).  Facts, all
elementary:

1. **Forced section.**  \(\{s_0=s_1=0\}\), the \(\mathcal O(-3)\)-section
   \(P\cong\mathbf P^2\), lies in every member (it is the base locus of
   the linear system).  \(X\) is smooth along \(P\) iff
   \((c,d)\ne(0,0)\), and smooth elsewhere for general \((A,B,C)\) by
   Bertini; fix a general smooth member.
2. **Minimal conic bundle, \(b_3=0\).**  \(\rho(X)=\rho(\mathbf P(E))=2\)
   (Lefschetz), so \(\rho(X/\mathbf P^2)=1\): relatively minimal, and the
   line cover is automatically irreducible (anatomy note §1).  The
   discriminant is \(\Delta=\{d^2A-2cd\,B+c^2C=0\}\), a general — hence
   smooth — plane cubic: \(p_a=1\), so \(b_3(X)=0\) by the formula.
3. **Not Fano.**  Adjunction gives \(-K_X=(\xi+3h)|_X\).  For a line
   \(\ell\subset P\), \(\xi\cdot\ell=\deg\mathcal O(-3)|_\ell=-3\), so
   \(-K_X\cdot\ell=0\): \(-K_X\) is nef but not ample.  \(X\) is a weak
   Fano whose \(K\)-trivial extremal ray contracts \(P\)
   (normal bundle \(\mathcal O_P(-3)\)) to a
   \(\tfrac13(1,1,1)\)-type point — the same singular germ as the E5
   class of the carrier structure theorem, so this family also sits at
   the door of class (c).

So \(X\) is a smooth minimal non-Fano conic bundle over \(\mathbf P^2\)
with smooth cubic discriminant and \(b_3=0\): **the first explicit member
of class (a)**, and structurally a Sarkisov-adjacent sibling of MM 2-24
(same \((\Delta,\text{cover})\)-type data, different total space).

## 3. Why this is the right test object

1. It is a divisor in a smooth toric bundle with weight data
   \((y_0,y_1,y_2;s_0,s_1;s_2)\mapsto(h,h,h;\xi,\xi;\xi+3h)\) and
   \(X\sim2\xi+3h\).  **Correction (2026-08-23, same day):** the class
   \(2\xi+3h\) is *not* nef — \(X\cdot\ell=-3\) on the lines of the
   forced section \(P\) (necessarily: \(P\) is the base locus), so
   convexity fails and the convex quantum-Lefschetz theorem does not
   apply on the nose.  The computable exact object is the *non-convex*
   twisted hypergeometric \(I\)-function (negative \(X\)-degrees
   contribute numerator factors), whose \(z\to0\) spectrum is an ambient
   probe of \(X\) rather than a certified computation of it; the failure
   of convexity is localized exactly in the \(K\)-trivial
   \(\ell\)-classes, i.e. in the direction treated as formal anyway.
2. The genuinely new wrinkle: \(-K_X\cdot\ell=0\) means the small quantum
   product carries a **degree-zero Novikov series** in the
   \(\ell\)-direction (contributions from multiples of the flopping-type
   lines in \(P\)) — the computation must treat that variable as a formal
   parameter or evaluate its (expected geometric) sum; this is exactly
   the technical profile non-Fano carriers were always going to have, met
   here in its mildest form.
3. **Prediction under test** (GS-carrier / Prym dictionary): the ledger
   of \(X\) contains no \(\{1/6,5/6\}\) block — its discriminant data
   carry no abelian Prym.  A marked block here would falsify the
   \(b_3=0\) tail programme in its weakest open case; no marked block is
   strong evidence for (GS-carrier) beyond the Fano world.

## 3b. First probe run (2026-08-23, same day)

Certificate: `notes/cubic-threefolds-tasks/c925-fable-weak-fano-ambient-probe.py`
(sha256 `7125a1c075fd9e839424c0c11484329f759a02eb708c19a77cdf030c2511e849`),
output `c925-fable-weak-fano-ambient-probe-output.txt` (sha256
`d4f2423da6305885caa2f49859f64455d315debb95a11d2bb2e9ba20601b5393`);
replay `uv run --with sympy python3 <script>` (about a second).

1. **The convexity obstruction is located and certified.**  The twisted
   hypergeometric coefficients violate the naive GKZ shift identity in
   the \(K\)-trivial direction already at class \(\ell\): the twist
   factor's negative-degree convention (Euler class of \(-H^1\), no
   \(m=0\) factor) breaks the product ratio exactly at twist-degree
   crossings.  The twisted D-module is not GKZ along the \(K\)-trivial
   ray — the precise technical form of the non-Fano difficulty.
2. **The valid ambient probe is clean.**  The untwisted toric
   \(\mathbf P(\mathcal O^2\oplus\mathcal O(-3))\) — which contains the
   same \(\tfrac13(1,1,1)\)-contracting section — has verified shift
   identities at all degrees, symbols
   \(R_2=\xi^2(\xi+3h)-w\), \(R_1=h^3-x\,\xi^6\) with \(\deg x=0\), and
   \(R_1\) exhibits the \(h\sim x^{1/3}\) sheets: a genuine three-cycle
   under the \(K\)-trivial Novikov loop.  At \(w=1\) and
   \(x\in\{1,-1,2,1/5\}\) the spectral scheme (dimension 12) has
   **squarefree** Kähler-direction characteristic polynomial in every
   case: the three-cycle sheets are simple, hence unmarked.  The
   ambient model shows exactly the benign scenario — cyclically permuted
   simple sheets, no \(J_2\), no exponent class to mark.

## 4. Residue table (corrected)

| base | residue |
| --- | --- |
| \(\mathbf P^2\) | non-Fano minimal conic bundles with cubic discriminant — explicit family in §2, test queued |
| general rational \(S\) | elliptic-configuration discriminants (Fano members closed; non-Fano members like §2's exist per base) |
| non-rational \(q=0\) \(S\) | untouched (Enriques sliver) |

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled (correction) | "Class (a) over \(\mathbf P^2\) empty" was an overreach; the degree consequence \(d=3\) stands, the Fano identification does not exhaust it. | §1. |
| settled | Explicit weak-Fano member: \(X\in\lvert2\xi+3h\rvert\) in \(\mathbf P(\mathcal O^2\oplus\mathcal O(-3))\), smooth, minimal, \(b_3=0\), not Fano; forced \(\mathbf P^2\)-section with \(K\)-trivial lines. | §2. |
| open, surprising link | The \(K\)-trivial ray of every such \(X\) contracts to the E5 germ \(\tfrac13(1,1,1)\): classes (a) and (c) of the structure theorem meet in this family — one Iritani-for-orbifold-blowups statement might close both at once. | §2.3; successor lever. |
| queued | Run the two-parameter \(I\)-function spectrum on §2's \(X\); the degree-zero Novikov series is the new technical gate. | §3. |

The E5-link row is the session's genuine surprise: the first non-Fano
carrier is one divisorial contraction away from the orbifold-blowup
technology that class (c) needs anyway.
