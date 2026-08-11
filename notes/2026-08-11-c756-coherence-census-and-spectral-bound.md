# C756 saturated-internal coherence census and the spectral barrier

**Lane:** `clebsch` · **Date:** 2026-08-11 · **Scope:** saturated-internal
branch; exhaustive census, one small structural theorem, one measured negative;
no manuscript edit

## Verdict

The saturated-internal branch is empty over every odd prime power
\(7\le q\le127\) and over \(q=169\), by exhaustive search, with \(q=5\)
returning exactly the two known four-frame supports.  In particular all three
forced tower-kernel seams \(q=25,27,81\) are closed as fields, so no parameter
remains where the digit-tower row count by itself forces a nonzero Cartier
kernel that the field's own classification has not already killed.

The census also fixes the structure of the object being searched.  The oriented
coherence relation is a Cayley graph on \(\mathrm{AGL}(1,q)\), regular of degree
exactly \((q^2-1)/4\) — proved below, not merely computed — on \(q^2-q\)
vertices.  Its largest nontrivial eigenvalue is \((q+1)/2\) in every computed
case, and the resulting Delsarte--Hoffman clique bound is

\[
 \omega\le\frac{2q(q-1)(q+3)}{3q^2-2q+3}
       =\frac43\cdot\frac{q+3}2\cdot\bigl(1+O(q^{-1})\bigr),
\]

which exceeds the required \(k=(q+3)/2\) by the factor \(4/3\) for every \(q\).
So the branch is not closable by any ratio-bound argument on this graph, and the
exact size of the shortfall is now known.  That is the useful negative: a
constant-factor improvement of \(4/3\) over the spectral bound would close the
saturated-internal branch over every field at once, and constant-factor
improvements of exactly this kind exist in the Paley-clique literature.

## 1. What was searched

By the dual-3-net reduction
(`notes/2026-08-10-c756-coherent-dual-three-net.md`, equations (3)--(5)), a
saturated-internal conic-filling arc over \(\mathbb F_q\) forces an oriented
support \(Z\subset\mathbb F_{q^2}\setminus\mathbb F_q\) with
\(|Z|=k=(q+3)/2\) and

\[
 \chi_{q^2}(z_i-z_j)=c,\qquad
 \chi_{q^2}(z_i-z_j^q)=-c
 \qquad(i\ne j),\qquad c=(-1)^{(q+1)/2}.
\]

Call such a set *coherent* and let \(\Gamma_q^{\mathrm{or}}\) be the graph these
two conditions define on \(\mathbb F_{q^2}\setminus\mathbb F_q\).  Coherence is
necessary and not sufficient: it ignores the arc condition and the covering
condition.  An empty census is therefore a complete negative for that field,
while a nonempty census must be filtered further, as it is at \(q=5\).

Both programs enumerate coherent sets through one fixed vertex.  That
normalization is free: the maps \(z\mapsto\lambda z+t\) with
\(\lambda\in\mathbb F_q^\times\), \(t\in\mathbb F_q\) preserve both character
conditions, and they act simply transitively on the \(q^2-q\) vertices, since
\((\lambda-1)z\in\mathbb F_q\) forces \(\lambda=1\) for irrational \(z\).  The
global flip \(z\mapsto z^q\) also sends coherent sets to coherent sets, which
fixes the choice of lift.

## 2. Census results

`coherent` counts normalized coherent \(k\)-sets; \(\omega\) is the largest
coherent set through the fixed vertex, which by transitivity is the clique
number of \(\Gamma_q^{\mathrm{or}}\).

| \(q\) | \(k=(q+3)/2\) | coherent \(k\)-sets | \(\omega\) |
|---|---|---|---|
| 5 | 4 | 2 | 4 |
| 7 | 5 | 0 | 3 |
| 9 | 6 | 0 | 4 |
| 11 | 7 | 0 | 5 |
| 13 | 8 | 0 | 6 |
| 25 | 14 | 0 | 8 |
| 27 | 15 | 0 | 9 |
| 49 | 26 | 0 | 10 |
| 81 | 42 | 0 | 10 |
| 121 | 62 | 0 | 12 |
| 125 | 64 | 0 | 12 |
| 169 | 86 | 0 | not computed |

The full certificate has thirty-seven rows; the largest maximum coherent set
anywhere in it is \(14\), at \(q=113\), against a required \(58\).

Every odd prime power \(7\le q\le127\) returns zero, as does \(q=169\); the
complete row set is in the certificate.  The required size grows linearly while
the largest coherent set grows like \(\log q\), so the surviving examples are
not near misses: at \(q=169\) an \(86\)-element coherent set is required and
nothing above a dozen elements exists.  \(q=5\) is the only field where the
maximum coherent set reaches the required size, and its two normalized sets are
the projective four-frame already classified.

## 3. The three forced seams

The card's digit-tower analysis leaves exactly three parameters where row count
alone forces a nonzero kernel of the stacked Cartier--Toeplitz matrix
\(\mathbb M_R\): \(q=25,27,81\).  All three are now closed as fields:

- \(q=25\) and \(q=27\) were already closed by the tracked 2026-08-01
  saturated-internal audit, whose `coherent` column is zero for both.  The card
  recorded only \(q=9\) as closed by that audit and did not connect the other
  two rows to the seams.
- \(q=81\) is closed here.

A general saturated-internal argument therefore no longer has to survive a
dimension-forced tower kernel.  Outside these three fields every tower kernel is
a rank-drop stratum, and inside them the field is finished by exhaustion.

## 4. The graph, its degree, and the spectral barrier

**Degree (proved).**  Fix a vertex \(z\) and put \(\delta'=z-z^q\), which is
nonzero and trace-zero, so \(\chi_{q^2}(\delta')=c\) by equation (5) of the
dual-3-net note.  Writing \(u=w-z\), a vertex \(w\) is adjacent to \(z\) exactly
when \(\chi(u)=c\) and \(\chi(u+\delta')=-c\); rational \(w\) are excluded
automatically, since for \(w\in\mathbb F_q\) the two characters are equal.
Hence

\[
 \deg=\frac14\sum_{u\ne0,-\delta'}\bigl(1+c\chi(u)\bigr)
                                  \bigl(1-c\chi(u+\delta')\bigr)
     =\frac14\Bigl[(q^2-2)-c\chi(\delta')+c\chi(\delta')+1\Bigr]
     =\frac{q^2-1}4,
\]

using \(\sum_{u}\chi(u(u+\delta'))=-1\) for \(\delta'\ne0\).  The graph is
regular of degree \((q^2-1)/4\) for every odd prime power, with no computation.

**Cayley structure.**  The simply transitive action of section 1 is the affine
group \(\mathrm{AGL}(1,q)=\mathbb F_q\rtimes\mathbb F_q^\times\), so
\(\Gamma_q^{\mathrm{or}}\) is a Cayley graph on it.  Its spectrum therefore
splits into \(q-1\) eigenvalues from the linear characters and the eigenvalues
of one \((q-1)\)-dimensional block, each repeated \(q-1\) times.  Multiplicities
are in the certificate.

**Computed spectra.**  For every computed field the largest nontrivial
eigenvalue is exactly \((q+1)/2\) and the least eigenvalue satisfies
\(\lambda_{\min}\le-(q-1)/2\), with equality at
\(q\in\{5,9,11,25,31,49,81\}\) — every computed square together with
\(5,11,31\).

**The barrier.**  A clique of \(\Gamma_q^{\mathrm{or}}\) is an independent set
of the complement, which is \((n-1-\deg)\)-regular with least eigenvalue
\(-1-\lambda_2\), \(\lambda_2=(q+1)/2\) the largest nontrivial eigenvalue.
Hoffman's coclique bound there gives

\[
 \omega\le\frac{n(1+\lambda_2)}{n-\deg+\lambda_2}
        =\frac{2q(q-1)(q+3)}{3q^2-2q+3},
 \qquad n=q^2-q,
\]

whose ratio to \(k=(q+3)/2\) is \(4q(q-1)/(3q^2-2q+3)\), increasing to \(4/3\).
Computed values of that ratio run from \(1.176\) at \(q=5\) to \(1.328\) at
\(q=81\); it is never below one.  So the ratio bound never closes the branch,
and it misses by a factor tending to \(4/3\).

Two traps are recorded so they are not rediscovered.  First, the frequently
quoted \(\omega\le1-\deg/\lambda_{\min}\) is **not** a valid clique bound for
regular graphs: the prism over \(K_5\) (two disjoint \(K_5\) joined by a perfect
matching) is \(5\)-regular with \(\lambda_{\min}=-2\), giving \(3.5\) against a
clique number of \(5\).  Applied here it would have given exactly \(k\), and at
seven fields exactly \(k\) with equality, which is a coincidence of this graph's
spectrum and proves nothing.  The self-test in the spectrum script pins both the
counterexample and the correct formula.  Second, the clique--coclique bound
\(\omega\alpha\le n\) for vertex-transitive graphs does give something
unconditional but weaker: for \(q\equiv1\pmod4\), where \(c=-1\), the vertical
line \(\{a+\delta:a\in\mathbb F_q\}\) is independent, because differences lie in
\(\mathbb F_q^\times\) and are squares of \(\mathbb F_{q^2}\); hence
\(\omega\le q-1\).  That is the first unconditional size bound available for
extension fields, and it is still short of \((q+1)/2\) by a factor two.

## 5. Replay

Working directory `~/src/othello`.

```
rustc -O -o /tmp/c756coh notes/2026-08-11-c756-coherent-orientation-census.rs
/tmp/c756coh > notes/2026-08-11-c756-coherent-orientation-census.json

uv run --with numpy python3 notes/2026-08-11-c756-coherence-spectrum.py \
  > notes/2026-08-11-c756-coherence-spectrum.json
```

Both are deterministic, take no options beyond an explicit \(q\) list, and with
no arguments regenerate exactly the tracked file.  On this host the census run
takes about eight minutes, dominated by \(q=121,125,169\), and the spectrum run
about two minutes, dominated by the \(q=81\) eigensolve.

Load-bearing conventions: \(c=(-1)^{(q+1)/2}\); the fixed vertex is the smaller
lift of the first trace-zero internal point (Rust) or \(\delta\) itself
(Python); `coherent` counts sets containing that vertex, not projective orbits;
the Rust program skips the maximum-clique pass above 4096 vertices, and the
Python program skips both searches above 2500 vertices and the eigensolve above
7000, reporting `null` rather than a partial value in each case.  Eigenvalues
are double-precision LAPACK values; every eigenvalue quoted as exact in section
4 is within \(10^{-9}\) of the stated rational, and no strictness claim is made
from a numerical margin below \(10^{-6}\).

SHA-256 and byte counts of the committed bundle:

```
5810acd7371be76cc65ccb2949752886c2dea1573d00f765f8244ee2af3565e7  15761  2026-08-11-c756-coherent-orientation-census.rs
f32d091553840a32b86de96d56b37995605f794ef5a3cb978470815fd01deb38   8491  2026-08-11-c756-coherent-orientation-census.json
598f199eabcdd3331a385bb3f4c37d0be018fbb1acf28cd5f1f8728b301635ef  13161  2026-08-11-c756-coherence-spectrum.py
70b3647fce7f94cb62f1fdecd39fd1bb86ffedc7925fbc4a85badc0d35916919   7228  2026-08-11-c756-coherence-spectrum.json
```

## 6. Independent cross-check

The two programs share no code.  The Rust census builds \(\mathbb F_{q^2}\) as
\(\mathbb F_p[x]/(g)\) for the first primitive \(g\) and reads characters from
discrete logarithms; the Python check builds
\(\mathbb F_{q^2}=\mathbb F_q[y]/(y^2-d)\) over
\(\mathbb F_q=\mathbb F_p[x]/(f)\) for the first irreducible \(f\) and the first
nonsquare \(d\), and reads \(\chi_{q^2}(a+by)=\chi_q(a^2-db^2)\).  Their search
implementations also differ.  On every common field the coherent counts and the
maximum coherent set sizes agree.

A third, older, independently written program agrees as well.
`notes/2026-08-01-c756-saturated-internal-audit.rs` enumerates unoriented
internal-point sets under chord externality and then tests whether the Segre
sign system is a coboundary; that coboundary sign is exactly the choice of lift
made here, so its `coherent` column must match, and it does on all fifteen
fields it covers \((q\le43)\), including the count \(2\) at \(q=5\).  Searching
the oriented graph applies both character conditions at every node of the search
rather than only at the leaves, which is what makes \(q\ge47\) reachable.

## 7. What this does not prove

- Nothing is proved for \(q>169\), for the prime powers strictly between
  \(127\) and \(169\), or for the nonsaturated branch.  The census is a bounded
  negative with the searched domain exactly as listed.
- The spectral regularities \(\lambda_2=(q+1)/2\) and
  \(\lambda_{\min}\le-(q-1)/2\) are computed on seventeen fields, not proved.
  Only the degree formula is proved.
- Coherence is necessary only; a nonempty census would not by itself produce a
  conic-filling arc.
- The maximum-clique values are exact where reported and `null` where the pass
  was skipped; no estimate is substituted.

## 8. EJ + TT closeout

**EJ.**  Three things came free with the census.  The degree formula is a
two-line character sum and holds for all \(q\).  The clique--coclique bound
gives the first unconditional bound \(\omega\le q-1\) for \(q\equiv1\pmod4\),
where before there was none for extension fields.  And the shortfall of the
spectral method is now an exact constant rather than a vague "spectral methods
are weak here": the ratio bound is \(4/3\) of the required size in the limit,
so the branch would close under a \(25\%\) improvement of the ratio bound.
That is the same shape as the known constant-factor improvements over
\(\sqrt p\) for clique numbers of prime-order Paley graphs, obtained by
polynomial-method arguments rather than by spectra; if such an argument
transfers to \(\Gamma_q^{\mathrm{or}}\) it closes the saturated-internal branch
over every field.  The transfer is not automatic and the cited improvement must
be checked against its source before it is used — this note asserts only the
size of the gap, not that the literature closes it.

**TT.**  The 2026-08-10 instruction not to return to fixed-\(q\) censuses
remains right as a strategy; what justified this one is narrow, namely three
named parameters the digit tower could not cover by dimension count, finished
more cheaply by exhaustion than by strengthening the tower.  The question to ask
next is which part of the \(\mathrm{AGL}(1,q)\) spectrum carries \((q+1)/2\) and
\(-(q-1)/2\): if these are linear-character (Jacobi sum) eigenvalues, both
regularities are short exercises and the \((q-1)\)-dimensional block only has to
be shown no larger, which would make the whole spectral picture closed-form and
the \(4/3\) gap exact rather than empirical.  The multiplicities in the
certificate are the data for that question.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Are the three forced tower seams real obstructions? | settled | no; \(q=25,27,81\) are empty by exhaustion |
| Was the 2026-08-01 audit already covering two seams? | settled | yes, \(q=25,27\); the card had not connected them |
| Is the degree exactly \((q^2-1)/4\)? | proved | none |
| Is \(\lambda_2\) exactly \((q+1)/2\)? | computed on 17 fields | closed-form \(\mathrm{AGL}(1,q)\) spectrum |
| Is \(\lambda_{\min}\le-(q-1)/2\) always? | computed on 17 fields | same |
| Which \(q\) attain \(\lambda_{\min}=-(q-1)/2\)? | open | \(\{5,9,11,25,31,49,81\}\): all computed squares plus \(5,11,31\) |
| Can a spectral bound close the branch? | settled, negative | ratio bound is \(4/3\) of \(k\) in the limit; a \(25\%\) gain is needed |
| How large can a coherent set be? | open | computed \(\omega\) grows like \(\log q\); best proved bound is \(q-1\), and only for \(q\equiv1\pmod4\) |
| Why is \(q=5\) exceptional? | open in this language | it is the only field where \(\omega\) reaches \(k\); no bound yet separates it |

## Next action

Do not extend the census.  Compute the \(\mathrm{AGL}(1,q)\) spectrum of
\(\Gamma_q^{\mathrm{or}}\) in closed form — the \(q-1\) linear-character
eigenvalues as Jacobi sums and the \((q-1)\)-dimensional block separately — to
turn \(\lambda_2=(q+1)/2\) and \(\lambda_{\min}\le-(q-1)/2\) into theorems and
the \(4/3\) shortfall into an exact statement.  Then attack the shortfall with a
polynomial-method argument in the style of the constant-factor improvements to
the Paley clique bound, which is the only identified route that could close the
saturated-internal branch for all \(q\) at once.
