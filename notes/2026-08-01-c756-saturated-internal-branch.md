# C756 — saturated-internal branch: canonical tangents, sign coherence, and the balanced double-clique reduction

**Lane**: `clebsch` · **Date**: 2026-08-01 · **Task**: C756 · **Scope**: research only

## Verdict

The saturated-internal branch is **not closed**, but it is reduced to a single sharp
gate, and the reduction is proved, not conjectured. The chain is:

1. internal points admit a **canonical, scale-free tangent polynomial** — unlike the
   saturated-external branch, Segre's lemma of tangents applies with **no scaling
   ambiguity to pin**, and forces an unconditional **sign-coherence theorem**: the
   conjugate representatives \(z_i\in\mathbb F_{q^2}\) of a saturated-internal arc can
   be chosen with
   \[
     \chi_{q^2}(z_i-z_j^q)=(-1)^{t+1},\qquad
     \chi_{q^2}(z_i-z_j)=(-1)^{t}\qquad(i\ne j),\qquad t=\tfrac{q+1}{2};
   \]
2. hence \(Z\cup Z^q\) is **two \((q{+}3)/2\)-cliques joined by the exact conjugation
   matching** in the Paley graph of order \(q^2\) (in its complement when
   \(q\equiv1\bmod4\)), sitting at **exactly tight** spectral interlacing; a Rayleigh
   argument turns tightness into a **balance theorem** — the character potential
   \(S(w)=\sum_i\chi_{q^2}(w-z_i)\) is Galois-symmetric, \(S(w)=S(w^q)\) for every
   \(w\) off the configuration — and Parseval pins \(k=(q+3)/2\) as the **only**
   self-consistent size;
3. the exhaustive audit (all odd prime powers \(q\le43\)) shows the branch dies in a
   residue-split way: for \(q\equiv1\pmod4\), \(q>5\), **no candidate survives even the
   pairwise character stage** (the largest pairwise-passant internal set through a
   point has size exactly \((q+1)/2\), the external-line bound); for
   \(q\equiv3\pmod4\) character candidates always exist — including one canonical
   polar-line-plus-apex set — but **none is coherent**, so none is an arc.

The remaining gate: **prove that no coherent system exists for \(q>5\)** (each residue
class may need its own argument). No cheap parity kill exists — the complete-mapping
obstruction of the external branch provably has no internal counterpart (§1), which is
why \(q=5\equiv1\bmod4\) survives there and here. The bounded literature check found no
prior classification of large exterior sets of internal points; the
Blokhuis–Seress–Wilbrink / Van de Voorde line treats exterior points only, with parity
roles mirroring ours.

Throughout: \(q\) odd, \(k=(q+3)/2\), \(t=q+2-k=(q+1)/2\) tangents per arc point,
\(\sigma=(-1)^{t+1}\), \(c=(-1)^{t}\). All statements below are proved unless marked
computed or open; §6 gives the ledger.

## 1. Circle normal form and the absent parity obstruction

Internal points of the conic are irreducible binary quadratics \(f_i\), i.e. conjugate
pairs \(\{z_i,z_i^q\}\), \(z_i\in\mathbb F_{q^2}\setminus\mathbb F_q\); the branch
condition is \(\chi_q(\operatorname{Res}(f_i,f_j))=-1\) for all pairs, equivalently
\(\chi_{q^2}\bigl((z_i-z_j)(z_i-z_j^q)\bigr)=-1\), since
\(\chi_{q^2}=\chi_q\circ N\).

Fix one arc point \(P_0\) (transitivity of \(\mathrm{PGL}(2,q)\) on internal points) as
\(z_0\) of trace zero and pass to the circle coordinate
\(u=(z-z_0)/(z-z_0^q)\). The Galois involution becomes \(\tau(v)=v^{-q}\), the conic
becomes the norm-one circle \(\mu_{q+1}\), and every other internal point is an
inversive pair \(\{u,u^{-q}\}\) off the circle, \(u^{-q}=u/N(u)\).

**Lemma 1 (normal form).** For an internal point \(\{u,u^{-q}\}\):

* the pair condition against \(P_0\) is \(\chi_{q^2}(u)=-1\), i.e. \(N(u)\) is a
  nonsquare of \(\mathbb F_q\);
* the **angle** \(a(u)=u^{1-q}\in\mu_{q+1}\) is well defined on the pair, and
  \(a^{(q+1)/2}=\chi_{q^2}(u)=-1\): the angle lies in the **odd coset** of
  \(\mu_{(q+1)/2}\) in \(\mu_{q+1}\);
* two points are collinear with \(P_0\) iff their angles agree (the determinant
  through \((0,1,0)\) is the angle difference).

Consequently the \(k-1=(q+1)/2\) remaining points of a saturated-internal arc have
distinct angles in a coset of size \((q+1)/2\): **the angle map is a forced bijection
onto the odd coset**. This is the exact analog of the external branch's normal form,
with the cyclic square group replaced by the odd coset of the circle group.

**Why no mod-4 kill exists.** In the external branch, the second forced permutation
\(s\mapsto s\phi(s)\) made \(\pi\) a complete mapping of \(\mathbb Z/m\), impossible
for \(m\) even. Here the analogous global identity is the coset product
\(\prod_i a_i=(-1)^{(q+1)/2}\cdot(-1)^{[\,\frac{q+1}{2}\text{ even}\,]}\), and §3.3
shows the configuration satisfies it **automatically for every \(q\)** — it is a
constraint on derived quantities (the Vandermonde), not an obstruction. The parity
route that killed \(q\equiv1\pmod4\) externally provably has no internal counterpart;
the four-frame at \(q=5\equiv1\pmod4\) is consistent with this.

## 2. Canonical tangent polynomial and the sign-coherence theorem

At an arc point \(P_i\) the \(k-1=(q+1)/2\) chords are passants and exhaust the
passants through an internal point; the combinatorial tangents at \(P_i\) are therefore
**exactly the \(t=(q+1)/2\) secants of \(C\) through \(P_i\)** (an internal point lies
on no tangent of \(C\)).

For a plane point \(Q=(a{:}b{:}c)\) (the form \(f_Q=aX^2+bX+c\)), the two linear forms
\(w=f_Q(z_i)\), \(\bar w=f_Q(z_i^q)=w^q\) span the pencil at \(P_i\), and the ratio
\(\alpha=w/\bar w\in\mu_{q+1}\) is constant on each line through \(P_i\): the pencil is
canonically the circle group, and the line is a secant iff \(\alpha^{(q+1)/2}=+1\).
Define

\[
  T_i(Q)\;=\;\frac{f_Q(z_i)^{(q+1)/2}-f_Q(z_i^q)^{(q+1)/2}}{z_i^q-z_i}. \tag{1}
\]

\(T_i\) is \(\mathbb F_q\)-rational, invariant under \(z_i\leftrightarrow z_i^q\)
(numerator and denominator both flip sign), homogeneous of degree \(t\), and vanishes
to order one exactly on the \(t\) secant lines through \(P_i\): **a canonical tangent
polynomial with no free scalar**. This is the structural advantage over the
saturated-external branch, where pinning the Segre scale factors needed the fixed edge.

For another arc point \(P_j\), \(\chi_{q^2}(f_j(z_i))=-1\) (passant condition) makes
the two evaluations in (1) antipodal, so with \(\delta_i=z_i^q-z_i\),

\[
  T_i(P_j)\;=\;\frac{2\,f_j(z_i)^{(q+1)/2}}{\delta_i}\in\mathbb F_q^{\,*},
  \qquad
  R_{ij}:=\frac{T_i(P_j)}{T_j(P_i)}\;=\;s_{ij}\,\frac{\delta_j}{\delta_i},
  \qquad
  s_{ij}:=\chi_{q^2}(z_i-z_j^q), \tag{2}
\]

and \(s_{ij}=s_{ji}\). Segre's lemma of tangents in the triangle form (Ball, *On
Segre's lemma of tangents*, ENDM 2018, eq. for \(\deg g=0\)):
\(f_x(y)f_y(z)f_z(x)=(-1)^{t+1}f_x(z)f_y(x)f_z(y)\), which is scaling-invariant and so
applies verbatim to (1). The \(\delta\)'s cancel in the triple product of (2):

\[
  s_{ij}\,s_{jk}\,s_{ki}\;=\;(-1)^{t+1}\qquad\text{for every triple of arc points.}
  \tag{3}
\]

A symmetric sign system with constant triple product \(\sigma\) is \(\sigma\) times a
coboundary \(\varepsilon_i\varepsilon_j\), and swapping \(z_i\leftrightarrow z_i^q\)
flips \(\varepsilon_i\); hence:

**Theorem 2 (sign coherence).** The representatives of a saturated-internal arc can be
chosen so that for all \(i\ne j\)

\[
  \chi_{q^2}(z_i-z_j^q)=(-1)^{t+1},\qquad
  \chi_{q^2}(z_i-z_j)=(-1)^{t}. \tag{4}
\]

For \(q\equiv3\pmod4\) (\(t\) even): \(Z=\{z_i\}\) is a **clique** of the Paley graph
on \(\mathbb F_{q^2}\) and all conjugate-cross pairs are non-adjacent; for
\(q\equiv1\pmod4\) the roles are complemented. The diagonal is automatic and uniform:
\(\chi_{q^2}(z_i-z_i^q)=\chi_q\bigl(-\operatorname{disc}f_i\bigr)
=\chi_q(-1)\cdot(-1)=(-1)^{t}\) — the same sign as the within-\(Z\) pairs in (4), so
each conjugate pair \(\{z_i,z_i^q\}\) is an edge of the very graph in which \(Z\) is a
clique.

## 3. Consequences of coherence

### 3.1 Double clique with matching, at tight interlacing

Let \(A\) be the graph on \(\mathbb F_{q^2}\) with adjacency
\(\chi_{q^2}(x-y)=(-1)^t\) (the Paley graph for \(q\equiv3\bmod4\), its complement —
also a Paley-parameter graph — for \(q\equiv1\bmod4\)); eigenvalues
\(\tfrac{q^2-1}{2}\) and \(\theta_2=\tfrac{q-1}{2}\), \(\theta_{\min}=-\tfrac{q+1}{2}\).
By Theorem 2 and the diagonal computation, the induced subgraph on \(Z\cup Z^q\) is

\[
  H\;=\;K_k\sqcup K_k\;+\;\text{the perfect matching }\{z_i,z_i^q\},
\]

with spectrum \(\{k,\;k-2,\;0,\;-2\}\). Cauchy interlacing demands
\(\theta_2(H)=k-2\le\theta_2(A)=\tfrac{q-1}2\); at \(k=(q+3)/2\) this holds **with
equality**. (Without the matching the bound would be violated and the branch would
close instantly; the diagonal signs rescue it exactly.)

### 3.2 The balance theorem

**Theorem 3 (balance).** For any coherent system (character structure only, general
position not needed), the signed indicator \(x=\mathbf 1_Z-\mathbf 1_{Z^q}\) is a
\(\theta_2\)-eigenvector of \(A\). Consequently, with
\(S(w)=\sum_{i}\chi_{q^2}(w-z_i)\),

\[
  S(w)\;=\;S(w^q)\qquad\text{for every }w\in\mathbb F_{q^2}\setminus(Z\cup Z^q),
  \tag{5}
\]

while on \(Z\cup Z^q\) the deviation is forced: \(S-S\circ\mathrm{Frob}=\mp(2k-3)\)
on \(Z\) and \(Z^q\) respectively.

*Proof.* \(x\perp\mathbf 1\) and
\(x^{\mathsf T}Ax=2\bigl[2\binom k2-k\bigr]=2k(k-2)=\theta_2\|x\|^2\) exactly, so the
Rayleigh quotient on \(\mathbf 1^{\perp}\) is attained and \(Ax=\theta_2x\). Rows at
\(w\notin Z\cup Z^q\) give equal neighbor counts in \(Z\) and \(Z^q\), which is (5);
rows on \(Z\cup Z^q\) evaluate directly from the clique-plus-matching structure. ∎

The potential \(S\) is thus Galois-invariant off the configuration — constant on
conjugacy classes, "defined over \(\mathbb F_q\)". **Parseval pins the size:**
\(T:=S-S\circ\mathrm{Frob}\) is a \(\pm1\)-combination of the \(2k\) functions
\(\chi(w-a)\), whose Gram matrix is \(q^2I-J\), so \(\sum_wT(w)^2=2kq^2\); by (5) the
support of \(T\) is \(Z\cup Z^q\), where \(|T|=2k-3\). Hence \(2k(2k-3)^2=2kq^2\),
i.e. \(k=(q+3)/2\): **saturation is exactly spectral tightness**, and the balance
theorem is self-consistent at precisely the saturated size — the obstruction, if any,
is finer than spectral.

### 3.3 Coset products, master polynomial, Vandermonde rigidity

Transporting Lemma 1 to each arc point: the relative angle of \(P_j\) seen from
\(P_i\) is \(\alpha_{ij}=f_j(z_i)^{1-q}\); the \(k-1\) values \(\{\alpha_{ij}\}_{j\ne
i}\) are distinct and fill the odd coset, whose product is
\(c=(-1)^{(q+1)/2}=(-1)^t\). Therefore, for **every** \(i\):

* \(F_i:=\prod_{j\ne i}f_j(z_i)\) satisfies \(F_i^{\,q-1}=c\);
* equivalently, for the master polynomial \(G=\prod_{i}f_i\in\mathbb F_q[X]\)
  (squarefree, degree \(q+3\), no rational roots), using
  \(F_i=-G'(z_i)/\delta_i\) and \(\delta_i^{\,q-1}=-1\):
  \[
     G\;\bigm|\;G'^{\,q}-(-1)^{t+1}G' . \tag{6}
  \]
* multiplying \(\alpha_{ij}\alpha_{ji}=(z_i-z_j)^{2(1-q)}\) over all pairs:
  \((V^{1-q})^2=c^{\,k}=1\) for the Vandermonde \(V=\prod_{i<j}(z_i-z_j)\), so
  \(V^{\,q-1}=\pm1\) — \(V\) is rational or \(\sqrt d\)-anti-rational. With Theorem 2,
  \(\chi_{q^2}(V)=(-1)^{t\binom k2}\) pins the branch mod 8: \(q\equiv1\pmod 8\)
  forces \(V^{q-1}=-1\), \(q\equiv5\pmod8\) forces \(V\in\mathbb F_q^*\);
  \(q\equiv3\pmod4\) admits both signs consistently.

(6) is a Frobenius-divisibility hook of lacunary-polynomial type on a single rational
polynomial; it is a necessary condition, not equivalent to the branch.

### 3.4 The canonical extremal set for \(q\equiv3\pmod4\)

Two conjugate points (one on the polar of the other) that are both internal are joined
by a passant iff \(\chi_q(-1)=-1\): the restriction of the conic form to their join is
diagonal, with discriminant \(-Q(P)Q(R)\) of square class \(\chi_q(-1)\). Hence for
\(q\equiv3\pmod4\) the fixed internal point plus the \((q+1)/2\) internal points of its
**polar line** is a pairwise-passant set of size \((q+3)/2\) — never an arc (collinear
part), but it attains the character-stage maximum; the audit sees **exactly one**
line-plus-apex candidate at every \(q\equiv3\pmod4\), consistent with this
construction and its empirical uniqueness. For \(q\equiv1\pmod4\) the same joins are
secants and the construction fails — the visible source of the residue split in §4.

## 4. Exhaustive audit, all odd prime powers \(q\le43\)

Searcher: `notes/2026-08-01-c756-saturated-internal-audit.rs` (deterministic;
\(\mathbb F_{q^2}\) via the first primitive polynomial in a fixed encoding order; one
trace-zero internal point fixed; counts are normalized solutions, not projective
orbits). Certificate: `notes/2026-08-01-c756-saturated-internal-audit.json`.
Independent verifier (separate \((a,b)\)-pair field model and search):
`notes/2026-08-01-c756-saturated-internal-verify.py`, certificate
`notes/2026-08-01-c756-saturated-internal-verify.json`.

| \(q\) | \(k\) | max thru \(P_0\) | candidates | line-type | angle-biject | coherent | arcs | covering |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
|  5 |  4 |  **4** |  2 | 0 | 2 | 2 | 2 | **2** |
|  7 |  5 |  5 |  5 | 1 | 1 | 0 | 0 | 0 |
|  9 |  6 |  5 |  0 | 0 | 0 | 0 | 0 | 0 |
| 11 |  7 |  7 | 28 | 1 | 1 | 0 | 0 | 0 |
| 13 |  8 |  7 |  0 | 0 | 0 | 0 | 0 | 0 |
| 17 | 10 |  9 |  0 | 0 | 0 | 0 | 0 | 0 |
| 19 | 11 | 11 | 55 | 1 | 5 | 0 | 0 | 0 |
| 23 | 13 | 13 | 39 | 1 | 1 | 0 | 0 | 0 |
| 25 | 14 | 13 |  0 | 0 | 0 | 0 | 0 | 0 |
| 27 | 15 | 15 | 15 | 1 | 1 | 0 | 0 | 0 |
| 29 | 16 | 15 |  0 | 0 | 0 | 0 | 0 | 0 |
| 31 | 17 | 17 | 17 | 1 | 1 | 0 | 0 | 0 |
| 37 | 20 | 19 |  0 | 0 | 0 | 0 | 0 | 0 |
| 41 | 22 | 21 |  0 | 0 | 0 | 0 | 0 | 0 |
| 43 | 23 | 23 | 23 | 1 | 1 | 0 | 0 | 0 |

Columns: *max thru \(P_0\)* is the exact largest pairwise-passant internal set
containing the fixed point (probe capped at \(k+2\); never attained \(k+1\));
*candidates* = pairwise character condition only; *line-type* = the \(k-1\) non-fixed
points collinear (§3.4); *angle-biject* = no collinear triple through \(P_0\);
*coherent* = the sign system \(s_{ij}\) is a \((-1)^{t+1}\)-coboundary; *arcs* = full
general position; *covering* = condition (V). The two covering arcs at \(q=5\) are the
normalized four-frames.

Measured laws (computed, not proved):

* **(L1)** \(q\equiv1\pmod4\), \(q>5\): max \(=(q+1)/2\) exactly — the external-line
  clique bound is tight and the character stage alone kills the branch;
* **(L2)** \(q\equiv3\pmod4\): max \(=(q+3)/2=k\) exactly (never more), always with
  exactly one line-plus-apex representative;
* **(L3)** no coherent candidate exists for any audited \(q>5\) — for
  \(q\equiv3\pmod4\) this is where the branch dies, and by Theorem 2 it suffices;
* **(L4)** at \(q=5\) both covering arcs are coherent, as Theorem 2 requires.

Cross-checks: the arc counts agree with the earlier independent searcher
`notes/2026-08-01-c756-all-k-conic-filling-saturated.py` on its domain (\(q\le23\):
2 at \(q=5\), else 0); the Python verifier independently reproduces
candidates/coherent/arcs/covering for \(q\in\{5,7,11,13,19\}\) and runs the full
identity suite at \(q=5\) on both covering arcs — Segre triple identity (3), the
coherent normalization (4), tangent identification and exact factorization of (1),
evaluation formula (2), angle-coset bijection and product \(c\), \(F_i^{q-1}=c\),
divisibility (6), the \(q\equiv5\bmod8\) Vandermonde pin, and balance (5). All pass.

### Replay

From the repository root (total under ten seconds):

```sh
rustc -O -o /tmp/c756si notes/2026-08-01-c756-saturated-internal-audit.rs
/tmp/c756si > notes/2026-08-01-c756-saturated-internal-audit.json      # full table
python3 notes/2026-08-01-c756-saturated-internal-verify.py \
    notes/2026-08-01-c756-saturated-internal-audit.json 5 7 11 13 19 \
    > notes/2026-08-01-c756-saturated-internal-verify.json             # cross-check
```

Evidence hashes and byte counts:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-01-c756-saturated-internal-audit.rs`    | 18,067 | `c6a798f73fd1cf7ef9c33af1470d81dd477307e8773b7e18a3ad5bbaf553bd3e` |
| `notes/2026-08-01-c756-saturated-internal-audit.json`  |  3,842 | `acabee2fa04d61e6673c60a5cc429ba11f9e294e233a96c53d8451d91f6104d7` |
| `notes/2026-08-01-c756-saturated-internal-verify.py`   | 12,948 | `7d6a5b0f09bcb1ccb001e0f0bee202635468bc6ec46f01240863a59304415d48` |
| `notes/2026-08-01-c756-saturated-internal-verify.json` |    564 | `67b15f16e211dd5e9b3bba0a991258fea190d00eedc0c74f28196af2bc10f799` |

## 5. Literature boundary

Bounded check against the shared cache (`/tmp/persistent/tavis/lit-search`, `list`
plus targeted `get`/text greps); no external fetches were needed. Consulted:

* **Van de Voorde, *On sets without tangents and exterior sets of a conic***
  (arXiv:1201.0484): defines exterior sets (all secants external — our condition (E));
  every classification statement there concerns sets of **exterior points**; the
  Blokhuis–Seress–Wilbrink theorem quoted there (their [4]) says a \((q+1)/2\)-set of
  exterior points is collinear for \(q\equiv1\pmod4\), with non-collinear examples
  only at \(q=7,\dots,31\) for \(q\equiv3\pmod4\) (conjectured complete, checked
  \(q<131\)). **No classification of exterior sets of internal points** appears there
  or in any cached source. Verdict: the highest-value single find (a known internal
  classification closing the branch) does **not** exist in the searched domain. Our
  measured laws (L1)/(L2) are the exact internal mirror of the BSW parity split, with
  the residue classes exchanged and the extremal line replaced by an apex-plus-polar.
* **Ball, *On Segre's lemma of tangents*** (DOI 10.1016/j.endm.2018.06.003): supplies
  the triangle identity with sign \((-1)^{t+1}\) used in (3), scaling-invariant form.
* **Ball–Lavrauw, *Planar arcs*** (arXiv:1705.10940): coordinate-free lemma of
  tangents, background for §2.

Stop condition: cache-only, as directed by the task; targeted at exterior/internal
sets, Segre's lemma, and Paley-clique material. A full novelty audit (OpenAlex +
Crossref + Semantic Scholar per `notes/literature-audit-conventions.md`) is owed
before any manuscript claims novelty for Theorems 2–3.

## 6. Status ledger: proved / computed / open

* **Proved for all odd \(q\)**: Lemma 1 (angle-coset bijection normal form); the
  canonical tangent polynomial (1) with evaluations (2); Theorem 2 (sign coherence),
  via Segre's triangle identity; Theorem 3 (balance) with the Parseval size pin;
  the coset-product family of §3.3 (\(F_i^{q-1}=c\), divisibility (6), Vandermonde
  rigidity with mod-8 pin); the polar-plus-apex construction for \(q\equiv3\pmod4\);
  the non-existence of a complete-mapping-type parity obstruction.
* **Computed (exhaustive, \(q\le43\))**: the audit table and laws (L1)–(L4); the
  classification consequence — no saturated-internal conic-filling arc except the
  \(q=5\) four-frame — was already certified by the first-pass classification and is
  re-derived here with the killing stage localized.
* **Open (the gate)**: prove that no coherent system of size \((q+3)/2\) exists for
  \(q>5\). By Theorem 2 this closes the saturated-internal branch entirely. Balance
  (Theorem 3) constrains it exactly to the tight-eigenvector stratum but is
  self-consistent there; the disproof must use structure beyond the spectrum —
  candidates: the equitable-partition rigidity of the tight eigenvector, the
  angle-bijection at all \(k\) base points simultaneously, or a Blokhuis-style
  lacunary argument on (6). Secondary open item: prove (L1) (the character-stage
  vanishing for \(q\equiv1\pmod4\)), for which the failure of the polar construction
  is the visible mechanism but not yet a proof.

## 7. EJ + TT closeout

Cheap upgrades already taken during the pass: the Parseval identity upgrading balance
from a constraint to an exact size characterization (saturation \(=\) tightness); the
polar-line identification of the unique line-type extremal set; the mod-8 Vandermonde
pin; the max-clique column that turned the audit from a re-derivation into a
localization of the kill.

What Tao would ask, and the answers on record: *"Where exactly does the branch die,
and is the mechanism uniform?"* — measured: at the character stage for
\(q\equiv1\bmod4\), at coherence for \(q\equiv3\bmod4\); not uniform, and that split
is now a theorem-shaped target. *"Is the tightness a coincidence?"* — no: Parseval
shows \(k=(q+3)/2\) is the unique size where a balanced double clique can exist, so
the saturated size is spectrally distinguished; every counting argument in this task
family lands on a razor edge for the same reason, and any closing argument must be
finer than the spectrum. *"Does the internal branch really have no analog of the
external mod-4 kill?"* — proved absent, not merely unfound (§1).

Distinct next attacks (alt-attack inventory for the successor):

1. **Tight-eigenvector rigidity.** \(x=\mathbf 1_Z-\mathbf 1_{Z^q}\) lies in the
   \(\theta_2\)-eigenspace of a Paley-parameter graph, which is spanned by explicit
   Gauss-sum characters; expanding \(x\) there converts coherence into a system of
   exact character-sum equations — the sharpest known handle on the gate.
2. **Simultaneous angle bijections.** Balance used one global vector; the forced
   angle bijection holds at every arc point, and their interaction (a doubly
   stochastic-like constraint on the \(\alpha_{ij}\) table) is unexploited.
3. **Lacunary route.** Divisibility (6) puts \(G'\) in the kernel of a Frobenius-type
   operator mod \(G\); Blokhuis-style degree accounting on \(G'^q\mp G'\) with the
   known factor structure of \(G\) may bound \(q\).
4. **Covering side.** Everything above uses (E) only; the covering condition (V) has
   not been touched in this branch beyond the certified table.

## 8. Mystery ledger

| feature | settled by this pass? | exact gap / owner |
|---|---|---|
| Saturated-internal arcs are sign-coherent | **yes — proved** (Theorem 2), verified at \(q=5\) | none |
| The branch dies at different stages per residue class (character stage for \(q\equiv1\bmod4\), coherence for \(q\equiv3\bmod4\)) | measured, mechanism identified (polar construction exists iff \(\chi(-1)=-1\)) | prove (L1) and "no coherent system, \(q>5\)"; owner: successor C-item on the coherent double-clique gate |
| Tight interlacing at exactly \(k=(q+3)/2\) | **yes — explained**: Parseval forces \((2k-3)^2=q^2\); saturation \(=\) spectral tightness | none — but it proves the closing argument must be finer than spectral |
| No internal analog of the external complete-mapping mod-4 kill | **yes — proved absent** (§1) | none |
| Exactly one line-type extremal candidate at every \(q\equiv3\pmod4\) | existence proved (polar-plus-apex); uniqueness measured | prove uniqueness; likely a short polarity argument; owner: same successor |
| \(q=19\) has 5 angle-bijective candidates where every other \(q\equiv3\bmod4\) has 1 | no | unexplained outlier; inspect the four non-line \(q=19\) candidates for structure; owner: successor, low priority |
| Balance is rep-dependent (stated for coherent representatives) yet \(S(w)=S(w^q)\) is a strong global law | yes — consistent at \(q=5\) | none open; noted so the successor states it with the right quantifier |

No manuscript files were edited. No git commands were run by this task.
