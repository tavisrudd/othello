# C756 — all-\(k\) conic-filling classification: reformulation, two uniform bounds, and a bounded classification

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Task card**: `notes/clebsch-tasks/c756-all-k-conic-filling.md`

## Target

> For every \(k\) and every prime power \(q\), the only \(k\)-arcs in \(\mathrm{PG}(2,q)\)
> whose uncovered locus \(\mathcal U(A)\) is the full point set of a nonsingular conic are
> the projective four-frame over \(\mathbb F_5\) and the Clebsch hexagon over \(\mathbb F_{11}\).

**Status: not proved.** What this task establishes is a different presentation of the
problem, two new \(k\)-uniform necessary conditions, an exact structural dichotomy that
locates both known examples, and a complete classification — every \(k\) at once — for
the odd prime powers listed in the table below. It also states precisely why the
counting route cannot close the general theorem, with the measurement that shows it.

## 1. Reformulation: conic-external arcs plus covering

Let \(C\) be a nonsingular conic and \(A\) a \(k\)-arc, \(k\ge 2\).

**Lemma 1 (splitting).** \(\mathcal U(A)=C\) if and only if

* **(E)** every chord of \(A\) is *external* to \(C\) (disjoint from it), and
* **(V)** the chords of \(A\) cover all \(q^2\) points off \(C\).

*Proof.* If \(\mathcal U(A)=C\), a chord meeting \(C\) would cover a point of \(C\),
so (E) holds; and every point off \(C\) is not in \(\mathcal U(A)\), so it lies on a chord,
which is (V). Conversely (E) puts \(C\subseteq\mathcal U(A)\) and (V) puts
\(\mathcal U(A)\subseteq C\). ∎

Call a set satisfying (E) a **conic-external arc**. Condition (E) is hereditary — every
sub-arc of a conic-filling arc is a conic-external arc — while (V) is not. This is the
split the chord-moment system does not see: the moments use only the number of chords,
never the fact that all of them avoid one conic.

**Lemma 2 (\(q\) is odd).** No conic-filling arc exists for even \(q\).

*Proof.* For even \(q\) every tangent of \(C\) passes through the nucleus \(N\), so every
line through \(N\) meets \(C\) and no external line passes through \(N\). By (E) no chord
covers \(N\), so \(N\in\mathcal U(A)\setminus C\). ∎

**Character form of (E).** With \(Q\) the quadratic form of \(C\) and \(B\) its
polarization, the line \(PP'\) is external exactly when the binary form
\(\lambda^2Q(P)+2\lambda\mu B(P,P')+\mu^2Q(P')\) is anisotropic, i.e.

\[
  \chi\bigl(B(P,P')^2-Q(P)Q(P')\bigr)=-1 .
\]

So a conic-external arc is a set of points in general position whose Gram matrix
\(M=(B(P_i,P_j))\), \(M_{ii}=Q(P_i)\), has rank \(3\) and **all \(\binom k2\) of its
\(2\times2\) principal minors of one fixed quadratic character**.

**Binary-quadratic dictionary.** Identify \(\mathrm{PG}(2,q)=\mathbb P(\mathrm{Sym}^2V)\),
\(V=\mathbb F_q^2\), a point being a binary quadratic form \(f\) up to scalars, with
\(C=\{\operatorname{disc}f=0\}\), so \(Q=\operatorname{disc}\). Writing \(f\) with root
pair \(\{z_1,z_2\}\) and \(g\) with \(\{w_1,w_2\}\) and expanding the two cross products
\(A_1=(z_1-w_1)(z_2-w_2)\), \(A_2=(z_1-w_2)(z_2-w_1)\) gives \(B(f,g)=-(A_1+A_2)\) and
\(\operatorname{disc}(f)\operatorname{disc}(g)=(A_1-A_2)^2\), hence the identity

\[
  B(f,g)^2-\operatorname{disc}(f)\operatorname{disc}(g)\;=\;4A_1A_2\;=\;4\operatorname{Res}(f,g).
\]

Since \(4\) is a square, **(E) becomes**

\[
  \boxed{\;\chi\bigl(\operatorname{Res}(f_i,f_j)\bigr)=-1\quad\text{for all } i<j.\;}
\]

External points of \(C\) are the split forms (unordered pairs in \(\mathbb P^1(\mathbb F_q)\)),
internal points the irreducible forms (conjugate pairs in
\(\mathbb P^1(\mathbb F_{q^2})\setminus\mathbb P^1(\mathbb F_q)\)); for two internal points
the criterion reads \(\chi_{q^2}\bigl((z-w)(z-w^q)\bigr)=-1\).

Two immediate consequences of the resultant form:

* **Two external arc points are disjoint pairs.** A shared root gives
  \(\operatorname{Res}=0\). Hence the external points of a conic-external arc form a
  *partial matching* of \(\mathbb P^1(\mathbb F_q)\), and at most \((q+1)/2\) arc points
  are external.
* Stickelberger gives no parity obstruction: the resultant enters
  \(\operatorname{disc}(fg)\) squared, so \(\prod_{i<j}\chi(\operatorname{Res})\) is not
  determined by the discriminants. Checked directly as well: for \(q=11,13\) all four
  values \(0,1,2,3\) occur for the number of external diagonal points of a conic-external
  four-arc, so there is no local parity constraint to exploit.

## 2. Two \(k\)-uniform necessary conditions

Write \(b=\binom k2\).

### 2.1 Covering LP bound

Every point off \(C\) has chord-degree \(d_P\ge1\); the \(k\) arc points have
\(d_P=k-1\); any other point carries a matching of chords, so \(d_P\le\lfloor k/2\rfloor\).
The two exact chord moments are \(\sum_P d_P=b(q+1)\) (chords are external, so all their
points lie off \(C\)) and \(\sum_P\binom{d_P}{2}=\binom b2\) (any two chords meet, and off
\(C\)). Maximizing the number of covered points subject to these — an LP whose optimum
sits on the two extreme degrees — gives

\[
  q^2\;\le\;k+\Bigl[b(q+1)-k(k-1)\Bigr]-\frac{6\binom k4}{\lfloor k/2\rfloor}.
\]

This is a genuine strengthening of the published bound in the regime the published proof
did not reach: the \(k\le 8\) statement \(q\le\frac{k(k-1)+3}{3}\) rests on
"at most three pairwise disjoint chords concur", which is only the accident
\(\lfloor k/2\rfloor=3\); the display above is the same argument with the correct degree
cap and holds for every \(k\).

### 2.2 Spare-external-line bound and the saturation dichotomy

**Lemma 3.** Let \(A\) be conic-filling. Then either

* **(G) generic:** \(\binom{k-1}{2}\ge q\); or
* **(S) saturated:** every external line through every arc point is a chord, which forces
  all arc points to have the same type and
  \[
     k=\tfrac{q+1}{2}\ \ (\text{all arc points external}),\qquad
     k=\tfrac{q+3}{2}\ \ (\text{all arc points internal}).
  \]

*Proof.* Suppose some arc point \(P\) lies on an external line \(\ell\) that is not a
chord. \(\ell\) misses \(C\), so all \(q\) points of \(\ell\setminus\{P\}\) must be
covered; chords through \(P\) meet \(\ell\) only in \(P\), and each of the
\(\binom{k-1}2\) chords missing \(P\) meets \(\ell\) in one point, giving (G). Otherwise
the number of external lines through each arc point equals \(k-1\); that number is
\((q-1)/2\) for an external point and \((q+1)/2\) for an internal one, and the two values
cannot both equal \(k-1\). ∎

Combining, every conic-filling arc satisfies
\(k\ge k_{\min}(q):=\max\bigl(k_{\mathrm{LP}}(q),\ \min(k_{\mathrm{line}}(q),\lceil (q+1)/2\rceil)\bigr)\).

**Both known examples are exactly the two saturated types.**
The four-frame over \(\mathbb F_5\) has \(k=4=(q+3)/2\) with all four points internal;
the Clebsch hexagon over \(\mathbb F_{11}\) has \(k=6=(q+1)/2\) with all six points
external. In each case the chords through an arc point exhaust the external lines
through it. Under the dictionary of §1 the two saturated families are:

* **saturated-external** — a *perfect matching* \(M\) of \(\mathbb P^1(\mathbb F_q)\) with
  \(\chi(\operatorname{Res}(e,e'))=-1\) for every two edges, whose \((q+1)/2\) forms are
  in general position;
* **saturated-internal** — \((q+3)/2\) distinct conjugate pairs \(\{z_i,z_i^q\}\) with
  \(\chi_{q^2}\bigl((z_i-z_j)(z_i-z_j^q)\bigr)=-1\), in general position.

Exhaustive search of both families (one representative fixed, legitimate because
\(\mathrm{PGL}(2,q)\) is transitive on external and on internal points) gives, for
\(q\le 23\):

| family | \(q\) with a solution | notes |
|---|---|---|
| saturated-external, pairwise condition only | \(5,7,11,13,17,19,23\) | plentiful |
| saturated-external **and an arc** | \(7,\ 11\) | \(q=7\) fails the covering LP; \(q=11\) is the Clebsch hexagon |
| saturated-internal **and an arc** | \(5\) | the four-frame |

The general-position requirement, not the character condition, is what kills the
saturated-external family from \(q=13\) on in this range.

## 3. Bounded classification: every \(k\), one \(q\) at a time

For a fixed \(q\), a conic-filling arc is a conic-external arc of size at least
\(k_{\min}(q)\). Let \(m(q)\) be the largest conic-external arc in \(\mathrm{PG}(2,q)\).
If \(m(q)<k_{\min}(q)\) then no conic-filling arc of **any** size exists over
\(\mathbb F_q\); otherwise the finitely many conic-external arcs of size
\(\ge k_{\min}(q)\) are enumerated and condition (V) is tested on each.

Searcher: `notes/2026-08-01-c756-all-k-conic-filling.rs`.
Certificate: `notes/2026-08-01-c756-all-k-conic-filling.json`.

**Result.** For every odd prime power \(q\le 43\), and for **every** arc size \(k\), the only
conic-filling arcs are the four-frame at \(q=5\) and the Clebsch hexagon at \(q=11\).
With Lemma 2 (even \(q\) impossible for all \(k\)), the classification is therefore
complete for all \(q\le 43\).

| \(q\) | \(k_{\mathrm{LP}}\) | \(k_{\mathrm{line}}\) | \(k_{\min}\) | \(m(q)\) | \(\binom{m}{2}/q\) | outcome |
|------:|--------:|----------:|------:|------:|-------:|---|
|   3 |  4 |  2 |  4 |  3 | 1.00 | none (counting) |
|   5 |  4 |  3 |  4 |  4 | 1.20 | **four-frame, \(k=4\)** |
|   7 |  5 |  4 |  5 |  4 | 0.86 | none (counting) |
|   9 |  6 |  5 |  6 |  4 | 0.67 | none (counting) |
|  11 |  6 |  6 |  6 |  6 | 1.36 | **Clebsch hexagon, \(k=6\)** |
|  13 |  7 |  7 |  7 |  6 | 1.15 | none (counting) |
|  17 |  8 |  8 |  8 |  6 | 0.88 | none (counting) |
|  19 |  8 |  8 |  8 |  6 | 0.79 | none (counting) |
|  23 |  9 |  9 |  9 |  8 | 1.22 | none (counting) |
|  25 |  9 |  9 |  9 |  8 | 1.12 | none (counting) |
|  27 |  9 |  9 |  9 |  9 | 1.33 | none (search) |
|  29 | 10 | 10 | 10 | 10 | 1.55 | none (search) |
|  31 | 10 | 10 | 10 | 10 | 1.45 | none (search) |
|  37 | 10 | 11 | 11 | 10 | 1.22 | none (counting) |
|  41 | 11 | 11 | 11 | 11 | 1.34 | none (search) |
|  43 | 11 | 11 | 11 | 11 | 1.28 | none (search) |

"counting" means \(m(q)<k_{\min}(q)\), so no arc of any size can even satisfy (E) at the
required size; "search" means the conic-external arcs of size \(\ge k_{\min}\) were
enumerated and none satisfies (V). Nine of the sixteen \(q\) fall on the first side and
seven on the second, which is itself the point of §4: the counting conditions are not by
themselves enough.

\(m(q)\) is the exact largest conic-external arc, computed in `max` mode. \(q=37\) is the
only row where the spare-external-line bound \(k_{\mathrm{line}}\) strictly exceeds the
covering LP bound, and there it alone decides the case: \(k_{\mathrm{LP}}=10=m(37)\)
would have required an enumeration, while \(k_{\mathrm{line}}=11>m(37)\) closes it.

## 4. Why this does not close the general theorem

The route above closes a given \(q\) outright when \(m(q)<k_{\min}(q)\). Both quantities
are \(\sqrt{2q}+O(1)\): \(k_{\min}\) by construction, and \(m(q)\) empirically, since the
column \(\binom{m(q)}{2}/q\) in §3 stays inside \([0.67,\,1.55]\) across the whole measured
range with no trend. The two thresholds therefore differ by an integer rounding, and
which one wins alternates: nine of the sixteen \(q\) are closed by counting and seven
need the enumeration. Counting alone will not close the theorem, and no refinement of it
will either — each further refinement of the covering bound (a second deleted point, a
concurrence point on the spare line) adds only \(O(1)\) to \(k_{\min}\), while
\(m(q)-\sqrt{2q}\) also grows by \(O(1)\) over the same range.

**The exact obstruction.** A proof of the full statement requires an upper bound

\[
  m(q)\;<\;\sqrt{2q}+O(1)
\]

for the largest arc all of whose secants avoid a fixed conic — and the measurements say
that inequality is tight, not generous, so it may simply be false for some \(q\). That is
the real news of this task.

The underlying object is a clique bound for a Paley-type graph: on the \(q^2\) points off
\(C\), adjacency \(\chi(B(P,P')^2-Q(P)Q(P'))=-1\) has the shape of the Paley graph of
order \(q^2\), whose clique number is exactly \(q\), attained by the subfield. Here the
analogous extremal cliques are the external lines, each a clique of size \(q+1\), and they
are collinear — so the general-position hypothesis is exactly what has to do the work, and
"largest clique avoiding the line-like cliques" is the regime in which Paley clique bounds
are open.

The naive random heuristic (edge density \(\tfrac12\)) would predict
\(m(q)=\Theta(\log q)\). It is wrong by a wide margin: the measured \(m(q)\) is
\(\Theta(\sqrt q)\), essentially \(\sqrt{2q}+O(1)\). The external lines and their
neighbourhoods carry far more structure than a random graph, and that structure is what
pushes \(m(q)\) up to the same order as the covering threshold. Any proof of the general
theorem therefore has to use condition (V) beyond counting; a clean bound on \(m(q)\)
alone will not do it, because \(m(q)\) and \(k_{\min}(q)\) are the same size.

Spectral interlacing is not the missing tool. The character matrix \(S=(\chi(u-v))\) on
\(\mathbb F_{q^2}\) satisfies \(S^2=q^2I-J\), so its principal submatrices have spectrum
in \([-q,q]\); for a conic-external arc of internal points the induced
\(2k\times2k\) matrix is \(\left(\begin{smallmatrix}E&-E+\Delta\\-E+\Delta&E\end{smallmatrix}\right)\)
with \(E\) a symmetric \(\pm1\) zero-diagonal matrix — a two-graph, defined up to
switching, and the golden conference matrix in the \(q=11\) case. Interlacing then only
bounds \(\lambda_{\max}(E)\le(q+1)/2\), which is vacuous in the range \(k\approx\sqrt q\).

Two attack routes remain, neither pursued to a conclusion here.

The first is to make the covering condition bite structurally rather than numerically.
Everything above uses (V) only through counts. The unused content of (V) is that the
chords must cover *specific* points: the whole of every tangent line, the whole of every
external line, and in particular the \(q\) points of every spare external line through an
arc point. Lemma 3 is the first and crudest consequence of that, and it was already
enough to isolate both known examples as the saturated cases. A version of Lemma 3 that
uses the *type* of the covering points — external lines carry \((q+1)/2\) internal and
\((q+1)/2\) external points, and both halves must be covered separately — is the natural
next step and has not been tried.

The second is a character-sum bound with the general-position hypothesis inserted, for
instance by counting arcs rather than cliques through a Weil bound on the product of the
quadratic forms \(D_i(X)=B(X,P_i)^2-Q(X)Q(P_i)\). Character sums bound *existence* from
below; converting one into a non-existence bound is exactly the missing step, and it is
the same step that is missing in the Paley clique problem.

## 5. What is and is not certified

* Lemmas 1–3 and the LP bound are proofs, valid for all \(k\) and all \(q\).
* The table in §3 is exhaustive finite verification over the stated \(q\), for **all**
  \(k\) simultaneously. It is not an unrestricted nonexistence statement.
* The \(m(q)\) values in the certificate are exact maxima over \(\mathrm{PG}(2,q)\): the
  driver re-runs the searcher in `max` mode whenever the target-pruned `classify` run
  returns only a lower bound. The classification itself never depends on \(m(q)\).
* The saturated-family tables are exhaustive for \(q\le23\) only.
* Independent replay: `notes/2026-08-01-c756-all-k-conic-filling-replay.rs` shares no
  code path with the searcher — it never builds the conic-external graph, never uses the
  character criterion and never uses the covering LP, and it does not know which conic it
  is looking for. It enumerates every arc of \(\mathrm{PG}(2,q)\) directly, keeps the
  exact uncovered set \(\mathcal U(A)\), and reports every arc whose \(\mathcal U(A)\) is
  the zero set of a nonsingular conic (a rank condition on the six-variable linear system
  plus an exact zero-set comparison). Its pruning is loss-free: \(\mathcal U\) shrinks
  whenever a point is added, so a branch with \(|\mathcal U|<q+1\) is dead. Optionally it
  fixes the standard frame, which is legitimate because \(\mathrm{PGL}(3,q)\) is
  transitive on four-point subsets in general position and carries conics to conics; the
  only arcs it then misses are triangles, and a triangle has \(|\mathcal U|=(q-1)^2\),
  which equals \(q+1\) only at \(q=3\), where the unrestricted enumeration reports no hit.

  Replay agreement (unrestricted for \(q=3,5,7,9\), frame-fixed above that):

  | \(q\) | 3 | 5 | 7 | 9 | 11 | 13 | 17 | 19 |
  |---|---|---|---|---|---|---|---|---|
  | conic-filling arcs found | 0 | all four-frames | 0 | 0 | the hexagon | 0 | 0 | 0 |

  The replay therefore independently confirms the classification for every odd prime
  power \(q\le19\), including both positive cases.

  At \(q=5\) the unrestricted run returns 15500 arcs, all of size 4 — exactly the number
  of unordered four-frames of \(\mathrm{PG}(2,5)\) \(\bigl(|\mathrm{PGL}(3,5)|/24\bigr)\),
  so *every* frame there is conic-filling; the frame-fixed run returns the single
  representative. At \(q=11\) the frame-fixed run returns six arcs of size 6, the six
  extensions of the standard frame to the Clebsch hexagon.

## 6. Replay

All commands are run from the repository root. Regenerating the full certificate takes
about half an hour, dominated by \(q=41,43\).

```sh
# certificate for the whole q-list (classify, plus a max-mode pass where needed)
python3 notes/2026-08-01-c756-all-k-conic-filling.py \
        --out notes/2026-08-01-c756-all-k-conic-filling.json
python3 notes/2026-08-01-c756-all-k-conic-filling.py --check     # byte-for-byte

# the saturated families of Lemma 3
python3 notes/2026-08-01-c756-all-k-conic-filling-saturated.py 5 7 11 13 17 19 23 \
        > notes/2026-08-01-c756-all-k-conic-filling-saturated.json

# single q, by hand
rustc -O -o /tmp/c756  notes/2026-08-01-c756-all-k-conic-filling.rs
rustc -O -o /tmp/c756r notes/2026-08-01-c756-all-k-conic-filling-replay.rs
/tmp/c756  classify 11        # the Clebsch hexagon
/tmp/c756  max 31             # exact m(31)
/tmp/c756r 5                  # independent replay, unrestricted, all four-frames
/tmp/c756r 19 frame           # independent replay, frame-fixed
```

Conventions: the conic is \(y^2-xz\); points of \(\mathrm{PG}(2,q)\) are listed as
normalized coordinate triples; \(\mathbb F_{p^n}\) uses the lexicographically first
monic irreducible polynomial found by the built-in search, and every reported statement is
invariant under the choice. No randomness is used anywhere.

Evidence hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-01-c756-all-k-conic-filling.rs` | 18,785 | `af695f4a768745475ddf0cf0fcdce2a45335c08afd32b463e9c72f667e072841` |
| `notes/2026-08-01-c756-all-k-conic-filling-replay.rs` | 14,198 | `1b9732e41a2081b83d1aae6618a304d42f09a1bb0b578529b9ef08251db53b6d` |
| `notes/2026-08-01-c756-all-k-conic-filling.py` | 4,493 | `51fc9df59502d7669a147e7ade5ce47137cf2514948ed79b179171f15a39da99` |
| `notes/2026-08-01-c756-all-k-conic-filling.json` | 3,215 | `5c9b62c2e9a5ea942a5d8c0f438b62827e852235b90397dc715d4d892ef2ba4b` |
| `notes/2026-08-01-c756-all-k-conic-filling-saturated.py` | 5,851 | `ec1b09bfdbbeeb1b3ac170bf7964b78034d065ea146383b1ba423f871e65c426` |
| `notes/2026-08-01-c756-all-k-conic-filling-saturated.json` | 1,913 | `1fb73a431db100cf7d8aac0e5131ccbdab8d9e5a67ef5c9dd520c6143a470655` |

## 7. Mystery ledger

| feature | settled by this task? | exact gap / owner |
|---|---|---|
| Both known examples are exactly the two *saturated* types of Lemma 3, and nothing else in the searched range is saturated | yes, for \(q\le23\) | whether saturation is impossible for every \(q>11\) is open; it reduces to: no perfect matching of \(\mathbb P^1(\mathbb F_q)\) with all pairwise resultants non-residues is in general position, and no analogous conjugate-pair system exists |
| \(m(q)\) tracks \(\sqrt{2q}\) rather than the random-graph heuristic \(\Theta(\log q)\) | partly — measured, not explained | the heuristic ignores that external lines are \((q+1)\)-cliques and that their neighbourhoods are highly structured; why the largest *arc*-clique lands at exactly the covering order \(\sqrt{2q}\) is unexplained, and it is the single most informative missing datum. Owner: any successor to this task |
| \(k_{\min}(q)\) and \(m(q)\) agree exactly at \(q=27,29,31,41\) | no | coincidence of two \(\sqrt{2q}+O(1)\) quantities, or a real matching structure? Deciding this decides whether route 1 of §4 can work |
| \(q\) even is excluded by one line (nucleus), while odd \(q\) needs everything above | yes | no gap; the nucleus argument is complete |
| The four-frame case is totally degenerate: **every** four-frame of \(\mathrm{PG}(2,5)\) is conic-filling (all 15500 of them) | yes | \(\mathrm{PGL}(3,5)\) is sharply transitive on frames, so this is one orbit; the \(q=5\) example is "the frame", not a special frame |
| No parity/Stickelberger obstruction on \(\prod\chi(\operatorname{Res})\) | yes, negative | the resultant appears squared in the discriminant; verified directly on four-arc diagonal types at \(q=11,13\) |
