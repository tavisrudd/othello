# C624: code-specific party-permutation extensions

**Lane:** `ame-lu`

**Status:** complete

## Result

For every requested finite example, the realized projective
party-permutation extension splits:

\[
  1\longrightarrow \Gamma\longrightarrow\widetilde\Gamma
    \longrightarrow\Pi\longrightarrow1.
\]

Here \(V=L_C\cong\mathbb F_q^6\) is the projective Pauli stabilizer,
\[
  \Gamma=V\rtimes K,\qquad
  \widetilde\Gamma=V\rtimes H,
\]
and the computation supplies a complement
\(\Pi\hookrightarrow H\).  Thus \(H\cong K\rtimes\Pi\), with the
action and a concrete complement recorded generator by generator in the
certificate.  This is the party-permutation extension.  It is independent
of the split Weil lift over the linear \(\mathrm{SL}_2(q)\) factor and the
nonsplit Heisenberg scalar extension over Weyl translations.

The exact groups are:

| configuration | \(K\) | \(\Pi\) | \(|H|\) | \(|\Gamma|\) | \(|\widetilde\Gamma|\) |
|:--|:--|:--|--:|--:|--:|
| \(q=11,\ t=2,\ z=1\) H3/Clebsch pencil class | \(C_{10}=T\) | \(S_5\) | 1,200 | 17,715,610 | 2,125,873,200 |
| \(q=11,\ t=10,\ z=9\) pencil class | \(C_{10}=T\) | \(S_4\) | 240 | 17,715,610 | 425,174,640 |
| \(q=11,\ S=\{0,1,2,3,4,5\}\) GRS | \(\mathrm{SL}_2(11)\) | \(V_4\) | 5,280 | 2,338,460,520 | 9,353,842,080 |
| \(q=11,\ S=\{0,1,2,3,4,6\}\) GRS | \(\mathrm{SL}_2(11)\) | \(C_5\) | 6,600 | 2,338,460,520 | 11,692,302,600 |
| \(q=11,\ S=\{0,1,2,3,5,6\}\) GRS | \(\mathrm{SL}_2(11)\) | \(S_3\) | 7,920 | 2,338,460,520 | 14,030,763,120 |
| \(q=11,\ S=\{0,1,2,3,5,9\}\) GRS | \(\mathrm{SL}_2(11)\) | \(D_{12}\) | 15,840 | 2,338,460,520 | 28,061,526,240 |
| \(q=17,\ t=-1\), tetrahedral GRS jump | \(\mathrm{SL}_2(17)\) | \(S_4\) | 117,504 | 118,177,537,824 | 2,836,260,907,776 |
| \(q=31,\ t=-1\), tetrahedral H3/\(A_5\) class | \(C_{30}=T\) | \(S_5\) | 3,600 | 26,625,110,430 | 3,195,013,251,600 |

The last \(q=11\) GRS party group is the dihedral group of order \(12\):
its element-order histogram is
\(1^1,2^7,3^2,6^2\).  This removes the order-only ambiguity left in the
earlier census.

The split-prime integral H3 representatives at
\((q,\tau)=(11,4),(19,5),(29,6),(31,13)\), with
\(\tau^2-\tau-1=0\), all have
\[
  K=C_{q-1},\qquad \Pi=S_5,\qquad |H|=120(q-1),
\]
and all four extensions split.  The \(q=11\) and \(q=31\) representatives
agree with the corresponding pencil classes above, although their
canonical sections need not have the same factor table.

## Outer action and the \(T\)-normalizer

Choose the certificate's normalized section \(s(1)=1\).  On the fixed
kernel
\(\Gamma=V\rtimes K\), its representative action is
\[
  \alpha_\pi(v,k)
   =\bigl(M_\pi v,\ s(\pi)k s(\pi)^{-1}\bigr).
\]
For generators of every \(\Pi\), the certificate records the exact
\(6\times6\) matrix \(M_\pi\) on the RREF basis of \(L_C\), the induced
permutation of every element of \(K\), and the six local symplectic
blocks of \(s(\pi)\).  These representatives determine the section-free
map \(\Pi\to\operatorname{Out}(\Gamma)\).

For every non-GRS pencil or H3 example, the restriction to
\(T\) is the sign action:
even party permutations centralize \(T\), while odd party permutations
invert it.  An odd lift is anti-diagonal in a logical encoder view.
Consequently party motion enlarges the fixed-party logical linear group
from \(T\) to its full normalizer
\[
  N(T)=T\rtimes C_2.
\]

For the four \(q=11\) GRS evaluation sets, the restriction to
\(\mathrm{SL}_2(11)\) is inner on even party permutations and is the
diagonal outer automorphism on odd ones.  The \(C_5\) party group is
entirely even.  In the characteristic-\(17\) tetrahedral embedding, both
parities act by inner automorphisms of \(\mathrm{SL}_2(17)\), so the
induced outer action on that linear kernel is trivial.  There is no
\(T\)-to-\(N(T)\) upgrade on a GRS row because its fixed-party group is
already \(\mathrm{SL}_2(q)\).

## Normalized factor sets and splitting

For every ordered pair \((\pi,\rho)\), the certificate stores
\[
  f(\pi,\rho)=s(\pi)s(\rho)s(\pi\rho)^{-1}\in K\subseteq\Gamma
\]
as an index into the canonical fixed-party kernel.  Both identity rows
are checked, and the ordered nonabelian associativity identity is checked
against the stored section actions.  The canonical factor sets are
usually nontrivial.  For example:

| configuration | entries | identity entries | distinct values in \(K\) |
|:--|--:|--:|--:|
| \(q=11,\ t=2\) | 14,400 | 3,040 | 10 |
| \(q=11,\ t=10\) | 576 | 256 | 6 |
| \(q=11\), GRS \(V_4\) row | 16 | 16 | 1 |
| \(q=11\), GRS \(C_5\) row | 25 | 10 | 5 |
| \(q=17,\ t=-1\) | 576 | 208 | 8 |
| \(q=31,\ t=-1\) | 14,400 | 3,360 | 14 |

Nontriviality of this chosen factor set is gauge-dependent and is not an
obstruction.  For each row the checker finds explicit lifts of two
generators whose subgroup has order \(|\Pi|\) and projects bijectively to
\(\Pi\).  It then closes that complement, stores the normalized correction
\(b(\pi)\in K\) with
\[
  s'(\pi)=b(\pi)s(\pi),
\]
and directly verifies that \(s'\) is a homomorphism.  Hence the transformed
factor set is identically one in every listed case.

## Completeness and proof boundary

For each code, the checker reconstructs the fifteen two-dimensional
four-support shortenings of the CSS Lagrangian.  A party permutation and
one anchor block force the other five local blocks.  It checks every
support overlap and then independently checks equality of the transformed
full six-dimensional Lagrangian.

The all-odd-field fixed-kernel theorem reduces the exhaustive anchor
domain without losing candidates:

- on a non-GRS row, every anchor lies in one of the two cosets
  \(T\) or \(JT\), so anchors \(I,J\) suffice after normalization;
- on a GRS row, the fixed kernel is all of \(\mathrm{SL}_2(q)\), so every
  lift can be normalized to anchor \(I\).

The checker therefore exhausts all \(720\) party permutations for each
row.  It constructs every canonical factor-set entry.  A splitting verdict
is positive only after an explicit complement is closed and verified, so
no negative inference from a bounded complement search is used.

As an independent replay, the six \(q=11\) rows are compared with C397's
separately generated full symplectic census.  The fixed-kernel order,
party-image order, and total symplectic order agree in every row.  The
new computation additionally identifies the party-group types, outer
actions, factor sets, and complements.

The H3 computation covers the four displayed split prime fields.  It does
not claim an all-good-reduction splitting theorem, classify inert
extension-field reductions, or classify arbitrary six-arcs.

## Reproduction

Run from the repository root:

```bash
python3 notes/2026-07-25-c624-ame-lu-party-extension-examples.py --check
sha256sum -c notes/2026-07-25-c624-ame-lu-party-extension-examples.sha256
```

The deterministic checker uses only the Python 3 standard library.  Its
load-bearing inputs are the hash-pinned C374 finite-field/stabilizer
implementation and the C397 \(q=11\) certificate used only for the
independent order cross-check.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| checker `.py` | 29,513 | `05dacfcc34d92423dbf20f38884c2c54997945c9c50531be24448b7da3ed1a8f` |
| certificate `.json` | 622,347 | `94171665d436cccc2182fc81b4d0cdfaa714262c92f2a4917b6589c9a709d35d` |

The trusted boundary is exact arithmetic in prime fields, finite Gaussian
elimination, the CSS stabilizer/Clifford dictionary, and the previously
proved fixed-kernel normalization theorem.  The output is canonical,
contains no timestamps or host paths, and `--check` regenerates it in
memory without changing the worktree.

## `ej` and Tao closeout

The cheap upgrade was to retain the full normalized factor sets instead
of reporting only group orders.  They show concretely why a nonidentity
factor table is not a nonsplitting verdict: the stored cochain trivializes
each one.  The second upgrade identifies the outer action uniformly.
Every non-GRS/H3 row uses party sign to invert \(T\), which explains the
logical \(T\)-to-\(N(T)\) jump; the GRS rows replace this by the corresponding
inner/diagonal-outer action on \(\mathrm{SL}_2(q)\).

The stress test separated all three extensions in the implementation and
report.  The complement found here lives in the projective
party-permutation extension.  It neither supplies a commuting lift of Weyl
translations nor changes the Weil/Heisenberg verdict.

## Mystery ledger

| feature | closeout status | evidence gap or owner |
|:--|:--|:--|
| Are the earlier \(q=11\) symplectic orders genuine extensions with identifiable party groups? | **Settled:** the groups are \(S_5,S_4,V_4,C_5,S_3,D_{12}\), with exact factor tables and complements. | none |
| Do the canonical nonabelian factor sets vanish? | **Settled negatively in general:** most chosen sections have nonidentity factors. | none; this is gauge-dependent |
| Do those factors obstruct splitting? | **Settled negatively for every listed row:** an explicit normalized cochain changes each factor set to one. | none |
| What causes the non-GRS logical enlargement? | **Settled:** odd party motion inverts \(T\), giving \(N(T)=T\rtimes C_2\). | none |
| Is the party split a Weil or Heisenberg split? | **Settled negatively:** the kernels and quotients differ; the three extensions remain separate. | none |
| Does the H3 result hold over every odd good reduction, including inert extension fields? | **Open beyond this finite task:** only the four displayed split-prime representatives were computed. | a separately allocated extension-field/general-reduction task |

**Vibe check:** the concrete examples are cleaner than the abstract risk
suggested: every requested party extension splits, but the canonical factor
sets are often substantially nontrivial.  The examples therefore validate
the nonabelian formalism rather than collapsing it to a tautological direct
product.
