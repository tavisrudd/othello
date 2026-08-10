# C904: CKS admissible graph covers and primitive quartic cusp widths

Date: 2026-08-10  
Scope: exact boundary calculation for the quartic shadow-sister route.  No
manuscript or Lean source was edited.

## Verdict

The four voltage classes and primitive Picard--Lefschetz forms are determined.
They reverse the provisional quartic cusp labeling in the earlier shadow note.
In the standard `Gamma_0(6)` marking the result is

\[
\begin{array}{c|c|c|c|c}
t&\tau&\Gamma&[a]&q_{\rm primitive}&\text{width}\\ \hline
\frac7{10}&\pm3/\sqrt5&\text{six-loop rose}&(1,1,1,1,1,1)&(L_1,b)&1\\
\frac14&0&\text{Petersen}&\text{all-edge one}&(L_2,2b)&2\\
\frac16&\pm1/\sqrt{-3}&K_5&\text{all-edge one}&(L_3,3b)&3\\
\frac12&\pm1&\text{Petersen}&\text{odd-conjugate pair}&(L_6,6b)&6.
\end{array}
\]

Here `L=A_5`, `L^#=L_6`, and `L_d` is the unique index-`d`
intermediate lattice between `L` and `L^#`.  The Igusa graph calculation is
naturally over `tau`; it gives twice the displayed primitive form because

\[
 t-\frac14=\frac{\tau^2}{4}.
\]

Consequently the Hauptmodul and the degree-three shadow map forced by the
already marked cusps are

\[
 \boxed{y(t)=-\frac{2t+1}{6t-1}},
\]

\[
 \boxed{
 T(t)=-\frac{80}{3}
 \frac{(t-\frac7{10})(t-\frac14)^2}
 {(t-\frac16)(t-\frac12)^2}.}
\]

Thus `T=0` has orders `1,2` at `t=7/10,1/4`, while `T=infinity`
has orders `1,2` at `t=1/6,1/2`.  This is a convention-independent
ramification check once `T=0` is the width-one `I_1` cusp and `T=infinity`
is the width-three `I_3` cusp.

## 1. What CKS proves geometrically

The exact source is Cheltsov--Kuznetsov--Shramov, arXiv:1712.08906, cached
SHA-256
`14c94b0b671cf5e172893086fed33f6600a593d74a5a83efda5384978022c598`.
The relevant chain is:

- Theorem 3.10 (p. 30): the singular Wiman--Edge fibers have dual graphs
  Petersen, `K_5`, and the one-vertex six-loop rose.
- Lemma 3.24 and the table following Lemma 3.28 (pp. 33--34):
  `s(tau)=(tau^3-tau)/(5tau^2+3)` and
  `t=(tau^2+1)/4`, with the exact special preimages.
- Proposition 3.30 (pp. 35--36): at every quartic-special preimage, every
  discriminant node has a rank-two conic fiber and the total-space
  singularity is a node.  Hence the limiting ruling cover is an unramified
  graph double cover.  The companion non-special preimages of the same
  singular sextics instead have rank-one fibers.
- Theorem 4.6 and Corollary 4.9 (pp. 39--41): after blowing up the discriminant
  nodes, the ruling cover is trivial over every rational normalized
  component.  Most importantly, Corollary 4.9 computes the sheet character:
  at `tau=0` the line stabilizer `S_3` fixes the two ruling components, while
  at `tau=+-1` it swaps them.  The proof evaluates `q_0` and
  `q_0+q_infinity` at `P=(0:1:1)` and applies the displayed order-two
  stabilizer.

The last item is precisely the geometric datum needed to distinguish the two
quartics above the same Petersen discriminant.  It is not an inference from
parameter counting.

## 2. Voltage classification

For a nodal union of rational components with dual graph `Gamma`, a connected
unramified graph double cover is a nonzero class
`[a] in H^1(Gamma,F_2)`.  Equivariance forces `[a]` to be group-fixed.
Exact enumeration gives

\[
 \dim_{\mathbf F_2}H^1(P,\mathbf F_2)^{A_5}=2,
 \qquad
 \dim_{\mathbf F_2}H^1(K_5,\mathbf F_2)^{A_5}=1.
\]

For Petersen, the three nonzero classes split under `S_5` as one fixed class
and one odd-conjugate pair.  The fixed class is represented by voltage one on
all fifteen edges; its component stabilizer fixes the two lifted vertices.
For either exotic class the `S_3` component stabilizer acts by sign, and an
odd Petersen automorphism exchanges the two classes.  CKS Corollary 4.9
therefore identifies

- `tau=0` with the all-edge-one, `S_5`-fixed class;
- `tau=+1,-1` with the two exotic classes, in an order depending only on the
  odd marking.

For `K_5`, the unique nonzero fixed class is again all-edge one.  For the
six-loop rose, transitivity on the six loops likewise leaves only the
all-one nonzero class.  The only datum not canonically named is which member
of the exotic Petersen pair is called `tau=+1`; it has no effect on the
lattice, width, or descended quartic.

## 3. Integral signed-cycle calculation

Orient the base edges and let `a_e in F_2` be the voltage.  With
`y_v=v_0-v_1`, the anti-invariant boundary column for `e:v -> w` is

\[
 -y_v+(-1)^{a_e}y_w.
\]

The anti-invariant cycle lattice is the saturated integral kernel of this
signed incidence matrix.  The principal Prym polarization is half the
restriction of the Jacobian polarization; the two lifted nodes therefore
contribute one copy, not two copies, of the edge-square form.  Explicit
unimodular changes of basis give

\[
\begin{array}{c|c|c}
\text{cover}&q&\det q\\ \hline
\text{six-loop all-one}&(L_1,b)&6\\
K_5\text{ all-one}&(L_3,3b)&162\\
P\text{ exotic}&(L_6,6b)=6A_5^\#&1296\\
P\text{ all-one over }\tau&2(L_2,2b)&1536.
\end{array}
\]

At a rank-two discriminant node, analytic congruence puts the conic matrix in
the form `diag(1,1,f)`; the two ruling nodes are smoothed with the same order
as the discriminant node `f=0`.  The Wiman--Edge pencil has primitive
edge-square monodromy at these fibers (Farb--Looijenga, Proposition 4.1,
pp. 18--20), and `s(tau)` is unramified at all four quartic-special `tau`
values.  Thus the graph forms above are the actual `tau`-Picard--Lefschetz
forms.  Only `tau=0` is ramified in the descent to `t`, so
`q_tau=2q_t` there.

## 4. Why the width is `d`, not `6/d`

Use the actual polarized marking

\[
 \Lambda=L^\# e\oplus Lf.
\]

An integral multiplicity matrix preserves this lattice exactly when its
lower-left entry is divisible by six, so its stabilizer is `Gamma_0(6)`.
At a cusp whose transverse integral lattice is `L_d`, the primitive
unipotent has variation `(L_d,d b)`.  Hence its standard `Gamma_0(6)` cusp
width is `d`.

The reciprocal answer `6/d` results from first reversing the summands to
`L e + L^# f`, obtaining `Gamma^0(6)`, and then forgetting that the conjugacy
which returns to `Gamma_0(6)` also exchanges the cusp labels.  That was the
exact flaw in the provisional quartic labeling.

The already fixed degree-three map

\[
 T=-\frac{(4y+3)(y+3)^2}{(y+1)^2}
\]

has source widths `1,2,3,6` at
`y=-3/4,-3,infinity,-1`, respectively: over the width-one `T=0` cusp the
ramification orders are `1,2`, and over the width-three `T=infinity` cusp
they are `1,2`.  Matching the graph widths gives the displayed new `y(t)`
and `T(t)` uniquely.

## 5. Reproducibility

Run:

```sh
python3 notes/2026-08-10-c904-quartic-admissible-cover-widths.py
```

The certificate independently enumerates the fixed voltage classes, checks
that the displayed signed-cycle bases are saturated, constructs their Gram
matrices, and verifies explicit unimodular isometries to the four
root--weight cusp lattices.

| file | SHA-256 |
|---|---|
| `notes/2026-08-10-c904-quartic-admissible-cover-widths.py` | `cce8266832b245d05546aff72a649cf033db5ea57bc03dd8fbd1b56f0f60d2ff` |
| `notes/2026-08-10-c904-quartic-admissible-cover-widths.out` | `5db590ca5d3f622ca2b6b242b4a1dd3fb0b3c37b41f5661232d95ca5b575b131` |

No manuscript or Lean file was edited.
