# C756 — digit tower and the composition normal form (twenty-fourth pass)

**Lane**: `clebsch` · **Date**: 2026-08-02 · **Task**: C756, saturated-internal branch,
Route F continuation

## Verdict

The digit-1 gate is **proved**, and the proof overshoots the session goal by a
large margin.  For every coherent double-clique system over a prime field, all
signed power sums up to the critical degree vanish, the Fourier valuation is
uniformly at least \(t+1=(q+3)/2\), and — the structural payoff — the system is
the fiber of a **rational polynomial of degree \((q+3)/2\) over a single
quadratic point**.  The master polynomial decomposes as
\(G=(R-\gamma)(R-\gamma^q)\) with \(R\in\mathbb F_q[X]\) monic and
\(\gamma\in\mathbb F_{q^2}\setminus\mathbb F_q\).  This is the bounded normal
form that the lacunary and Cartier routes failed to produce: the arc-sized
object is no longer \(G\) (degree \(q+3\)) but the pair \((R,\gamma)\), and the
classification gate becomes a completely-split-fiber problem of classical
monodromy type.

## Setup

A **coherent system** over odd \(q\) is a set
\(Z=\{z_1,\dots,z_{t+1}\}\subset\mathbb F_{q^2}\setminus\mathbb F_q\)
(\(t=(q+1)/2\)), no two elements conjugate, with

- (A) \(\chi(z_i-z_j)=(-1)^t\) for all \(i\ne j\),
- (B) \(\chi(z_i-z_j^q)=(-1)^{t+1}\) for all \(i\ne j\),

\(\chi\) the quadratic character of \(\mathbb F_{q^2}\).  Segre's lemma of
tangents forces every genuine saturated-internal arc into this form; the
remaining saturated gate is that no coherent system exists for \(q>5\).
Set \(x=\mathbf 1_Z-\mathbf 1_{Z^q}\) and
\(\widehat x(w)=\sum_z x(z)\zeta_p^{\operatorname{Tr}(wz)}\)
(\(\operatorname{Tr}\) to \(\mathbb F_p\)).

## Lemma 1 (balance is Parseval-automatic)

*For a coherent system, \(x\) is an exact eigenvector of convolution by
\(\chi\), so \(\widehat x\) vanishes identically on the nonsquare class.*

Proof.  Convolution by \(\chi\) has eigenvalue \(G_2\chi(w)\) on the character
\(\psi_w\) (\(w\ne0\)), where \(G_2=\pm q\) is the rational quadratic Gauss sum
of \(\mathbb F_{q^2}\), and eigenvalue \(0\) at \(w=0\).  Conditions (A), (B)
plus \(\chi(z-z^q)=(-1)^t\) (from \(\chi(\sqrt\varepsilon)=(-1)^t\)) give
\((\chi*x)(z)=q(-1)^t x(z)\) at every point of
\(Z\cup Z^q\).  Then
\(\|\chi*x\|_2^2=q^2\|x\|_2^2\) by Parseval, while the support already
carries \(\sum_{\operatorname{supp}x}|(\chi*x)|^2=q^2\|x\|_2^2\); hence
\(\chi*x\) vanishes off the support and \(\chi*x=q(-1)^tx\) globally.  The
eigenvalue computation \(\chi(w)G_2=q(-1)^t\) puts \(\widehat x\) on the square
class.  ∎

(This recovers the known balance theorem; the point is that it needs no
interlacing input, only (A), (B).)

## Lemma 2 (fiber balance)

*For every nonsquare \(w\), every fiber of
\(z\mapsto\operatorname{Tr}(wz)\) contains equally many points of \(Z\) and of
\(Z^q\).*

Proof.  \(\widehat x(w)=\sum_{c\in\mathbb F_p}N_w(c)\zeta_p^c=0\) with
\(N_w(c)\) the signed fiber count; the only integer relations among
\(1,\zeta_p,\dots,\zeta_p^{p-1}\) are multiples of their sum, so \(N_w\) is
constant, and \(\sum_cN_w(c)=\sum_zx(z)=0\) makes it zero.  ∎

Consequently \(\sum_z x(z)f(\operatorname{Tr}(wz))=0\) for **every** function
\(f\) and every nonsquare \(w\).

## Theorem 1 (sub-critical and critical moment tower; prime \(q\))

*Let \(q=p\) be prime and \(Z\) coherent.  Write
\(P_e=\sum_zx(z)z^e=s_e-s_e^q\), \(s_e=\sum_iz_i^e\).  Then \(P_{j+q(r-j)}=0\)
for every \(1\le r\le t\) and \(0\le j\le r\).  Equivalently every power sum
\(s_e\) with base-\(q\) digit sum at most \(t\) is rational — including
\(s_1,\dots,s_t\).*

Proof.  Fix \(1\le r\le t\) and expand, for nonsquare \(w\),
\[
 0=\sum_zx(z)\operatorname{Tr}(wz)^r
  =\sum_{j=0}^r\binom rj\,w^{e_j}P_{e_j},\qquad e_j=j+q(r-j).
\]
The exponent differences are \((j-j')(1-q)\) with
\(|j-j'|(q-1)\le r(q-1)\le t(q-1)=(q^2-1)/2\), with equality only for
\(r=t,\{j,j'\}=\{0,t\}\).  For \(r<t\) the \(e_j\) are distinct modulo
\((q^2-1)/2\), so restricting to the nonsquare coset of the index-two subgroup
\(S\le\mathbb F_{q^2}^\times\) and using linear independence of distinct
characters of the cyclic group \(S\), every coefficient
\(\binom rjP_{e_j}\) vanishes; \(\binom rj\not\equiv0\pmod p\) for \(r\le p-1\),
so \(P_{e_j}=0\).  At the critical level \(r=t\) only the extreme pair merges:
\(w^{qt}=w^t\,w^{(q^2-1)/2}=-w^t\) on nonsquares, and \(P_{qt}=-P_t\) (from
\(s_{qe}=s_e^q\)), so the merged term is \(+2w^tP_t\); independence of the
remaining exponents gives \(P_{e_j}=0\) for \(0<j<t\) and \(2P_t=0\), hence
\(P_t=0\).  Newton's identities (divisions only by \(1,\dots,t<p\)) then make
the elementary symmetric functions \(e_1,\dots,e_t\) of \(Z\) rational.  ∎

**Corollary 1 (digit-1 — the session goal).**  \(\sigma=\sum_iz_i\) is
rational for every coherent system: the case \(r=1\).

**Corollary 2 (uniform valuation).**  The \(\pi\)-digit of \(\widehat x\) at
level \(r\) is the same linear combination of the \(P_{e_j}\), so
\(v_\pi(\widehat x(w))\ge t+1\) at every frequency.  At level \(t+1\) the
merged pairs on the square class add instead of cancel, so \(t+1\) is the
generic value; the \(q=5\) frames attain it exactly
(\(v_\pi=4=t+1\), previously read as \(p-1\) — the identity \(t+1=p-1\) is a
\(q=5\)-only coincidence, like \((q-1)^2/2=q+3\)).

## Theorem 2 (composition normal form)

*Every coherent system over prime \(q\) is the full fiber of a monic rational
polynomial over a quadratic point: there exist monic
\(R\in\mathbb F_q[X]\) of degree \(t+1=(q+3)/2\) and
\(\gamma\in\mathbb F_{q^2}\setminus\mathbb F_q\) with*
\[
 Z=R^{-1}(\gamma),\qquad Z^q=R^{-1}(\gamma^q),\qquad
 G=\prod_if_i=(R-\gamma)(R-\gamma^q)=R^2-\operatorname{Tr}(\gamma)R
   +\operatorname N(\gamma).
\]

Proof.  \(H=\prod_i(X-z_i)\) has coefficients \(e_1,\dots,e_t\) rational by
Theorem 1; only the constant term can be irrational.  Set
\(R=H+\gamma\) with \(\gamma=-H(0)+\) (its rational part folded into \(R\));
concretely \(R\) is \(H\) with its constant coefficient replaced by a rational
representative and \(\gamma\) the correction.  If \(\gamma\) were rational,
\(Z\) would be Frobenius-stable, impossible since \(Z\cap Z^q=\emptyset\).
The \(t+1\) distinct \(z_i\) exhaust the degree-\((t+1)\) fiber, and the
displayed factorization of \(G\) is immediate.  ∎

So \(R-\gamma\) **splits completely over \(\mathbb F_{q^2}\)** with all roots
irrational — a totally split quadratic fiber.  The classification gate is now:
which monic rational \(R\) of degree \((q+3)/2\) admit a quadratic point
\(\gamma\) with totally split irrational fiber satisfying the two character
conditions (A), (B)?

## Worked example (both frames, \(q=5\), \(\varepsilon=2\))

- \(Z=\{\sqrt2,\,1+4\sqrt2,\,2+2\sqrt2,\,4+3\sqrt2\}\):
  \(R=X^4+3X^3+4X^2+2X\), \(\gamma=2+3\sqrt2\);
- \(Z=\{\sqrt2,\,4+4\sqrt2,\,1+3\sqrt2,\,3+2\sqrt2\}\):
  \(R=X^4+2X^3+4X^2+3X\), \(\gamma=2+2\sqrt2\).

Both satisfy \(G=(R-\gamma)(R-\gamma^q)\) coefficientwise; the two frames sit
over conjugate constructions.

## Computational verification

`2026-08-02-c756-digit-tower-composition.py --check` certifies, for all 129
bounded candidates in the canonical orientation:

- the first failing tower level equals the uniform \(\pi\)-adic valuation of
  \(\widehat x\), recomputed independently at a support frequency, in all 129
  cases (level 1 for the 114 candidates with irrational \(\sigma\); level 3
  for the thirteen \(q=23\) candidates; level \(t+1=4\) for the frames);
- the frames pass every level \(1\le r\le t\) and fail level \(t+1\); and
- the full Theorem 2 composition block holds for both frames.

Negative candidates fail at level 1 or 3, far below the coherent floor
\(t+1\) — the tower measures distance from coherence in a graded way no prior
statistic did.

## Why counting alone cannot finish

With \(v_\pi\ge t+1\) uniformly, the norm bound gives per-scaling-orbit
\(\ell^2\) mass at least \((p-1)p^{(p+4)/(p-1)}\) and at least
\(q^2/(q+3)(p-1)\) orbits, totalling on the order of \(p^2\cdot p\); the
Parseval cap is \(q^2(q+3)\approx p^3\).  The two sides differ by the factor
\(p^{4/(p-1)}(p+3)^{-2}p\cdot\) — no contradiction for any \(p\).  A pure
valuation-versus-Parseval count would need valuation near \(2p\), which the
tower cannot reach (levels beyond \(t+1\) yield pair *relations*, not
vanishing).  The finisher must therefore be the \((R,\gamma)\) classification,
not counting.

## Next gates (frozen)

1. **Fiber-splitting classification.**  Determine the monic
   \(R\in\mathbb F_q[X]\), \(\deg R=(q+3)/2\), with a totally split
   irrational quadratic fiber.  Tools: factorization/monodromy of
   \(R(X)-R(Y)\), value-set bounds, the exceptional-polynomial literature
   (Turnwald; Müller–Zieve).  Bounded remark: the pure Dickson mechanism
   needs \(\mu_{(q+3)/2}\subset\mathbb F_{q^2}\), i.e.
   \((q+3)/2\mid8\) (since \(q^2-1=(q+3)(q-3)+8\)), i.e. \(q\in\{5,13\}\) —
   and \(q=13\) is already excluded by the audit, so coherence kills the
   second Dickson window; making that exclusion structural is part of this
   gate.
2. **Coherence on the fiber.**  Re-express (A), (B) as character conditions
   on \(R\) along its fiber (resultant of \(R-\gamma\) with translates), to
   couple with gate 1.
3. **Bounded census.**  Enumerate all \((R,\gamma)\) with totally split
   irrational fibers for prime \(q\le43\) (a polynomial-space search,
   \(q^{t}\)-ish; shard if needed) to measure how rare split fibers are
   before coherence — calibrating whether gate 1 alone nearly closes the
   branch.
4. Extension fields: Lemmas 1–2 hold for all odd \(q\); Theorem 1's binomial
   expansion is prime-field.  The \(q=p^e\) tower needs the multi-digit
   (Stickelberger-type) expansion — fold into the existing \(q=27\) hygiene
   item.

## Replay

```sh
cd notes
python3 2026-08-02-c756-digit-tower-composition.py --check
```

- `2026-08-02-c756-digit-tower-composition.py`
  `50c52603237446421fc7618901231c8a23eef9ab3673cd894ceb38ed23118712`
- `2026-08-02-c756-digit-tower-composition.json`
  `0ad005c35d53fe9ba0b2b956535a6b09370d44cd10a4abe70b11246bad9178ec`

Input: `2026-08-02-c756-sparse-paley-trade-profile.py` (hash recorded in the
JSON); candidate enumeration and orientation are exactly the census's.

## EJ + TT closeout

**EJ.**  The free upgrades were taken in-pass: the critical level \(r=t\)
closes by the same reflection \(P_{qt}=-P_t\) that produced the two-valued
autocorrelation, so the tower reaches \(t+1\) rather than stopping at
\(t-1\); and Newton converts the tower directly into the composition normal
form, upgrading a valuation statement into a polynomial-decomposition
statement at zero extra cost.  Surprising and now explained: the census
values \(v\in\{1,3,4\}\) are exactly first-failing tower levels; \(v=2\) is
impossible because level 2 is a consequence of level 1 for conjugation-odd
vectors.

**TT.**  The Tao question "what is the *bounded* object here?" now has an
answer: \((R,\gamma)\), total description length \(O(q)\) rational
coefficients against the \(q^2/4\) constraints of coherence — the
overdetermination is finally visible in a normal form classical machinery
can attack (monodromy of \(R(X)-R(Y)\), value sets, exceptional
polynomials).  The sharpest skeptical check — does the tower really exceed
the known coherence content? — is settled by the exact match of tower levels
with the census valuations on incoherent controls, which no coherence-derived
statistic predicts.

## Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Do genuine saturated arcs force digit 1 (\(\sigma\) rational)? | settled positively | Corollary 1, from coherence alone |
| Why does \(v_\pi=2\) never occur? | settled | level 2 follows from level 1 by conjugation-oddness (Corollary 2 mechanism) |
| Does coherence force full flatness for \(q>5\)? | reframed | coherence forces \(v_\pi\ge t+1\) exactly generically; flatness beyond \(t+1\) is *not* forced — the classification lever is now \((R,\gamma)\), not valuations |
| What selects the thirteen \(\sigma_1=0\) candidates at \(q=23\)? | sharpened | they are the candidates passing tower levels 1–2 while incoherent; geometric label still open, log-only |
| Which \(R\) admit totally split irrational quadratic fibers? | open | next gate 1/3; Dickson window \(q\in\{5,13\}\) with \(q=13\) audit-excluded |
