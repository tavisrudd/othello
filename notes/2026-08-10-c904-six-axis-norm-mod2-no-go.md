# C904 six-axis norm combinations and the graph-transpose factor

Date: 2026-08-10
Status: exact integral no-go on the actual exotic principal lattice; exact
divisor-cut normalization
Scope: no manuscript, Lean, or commit change

## Verdict

No `F_2`-linear combination of the six `D5` elliptic norm endomorphisms is
invertible on the actual exotic principal homology lattice.

More precisely, for a subset `S` of the six axes,

\[
 \operatorname{rank}_{\mathbf F_2}
       \left(\sum_{i\in S}N_i\right)
       =2\min(|S|,6-|S|).
\]

Thus the maximum rank is six, attained by the twenty three-axis subsets;
rank ten never occurs.  There is consequently no odd determinant, no
adjugate/characteristic-polynomial Bezout identity with `2I`, and no bypass
of the scalar-six parity wall from sums of the `N_i`.

The proposed geometric realization also has an exact hidden factor.  The
transpose of the graph of the Fano fibration

\[
                       \gamma_H:S\longrightarrow E_H
\]

cannot be composed with the universal line to give the required
codimension-two cycle: without a divisor cut the composition has codimension
one on `E_H times X`.  Cutting by the incidence divisor `C_s` repairs the
codimension, but the resulting homomorphism is

\[
                           2i_H:E_H\longrightarrow J,
\]

not the primitive Rosati dual `i_H`.  Precomposing with `q_H` therefore gives
`2N_H`, not `N_H`.

This is not an accident of the incidence choice.  On the full saturated
Neron--Severi lattice of the Fano surface the fibre-degree ideal is `2Z`; on
the `D5`-fixed sublattice, the only channel which lands purely on the marked
elliptic axis, it is exactly `10Z`.  Since `q_Hi_H=[5]`, every
`D5`-equivariant divisor-cut construction is an **even** multiple of `i_H`.

## 1. The six integral norms

Let `v_1,...,v_6` be the six oriented axes, with

\[
 v_6=-\sum_{j=1}^5v_j,
 \qquad (v_i,v_i)=5,
 \qquad (v_i,v_j)=-1\quad(i\ne j).
\]

In the first-five-axis basis the coefficient polarization is

\[
                         G=6I_5-J_5.
\]

The six norm endomorphisms `N_i=5P_i` are the integral matrices

\[
 N_i=e_i(\text{row}_iG),\quad 1\leq i\leq5,
 \qquad N_6=J_5.
\]

They satisfy

\[
 N_i^2=5N_i,
 \qquad N_iN_jN_i=N_i\ (i\ne j),
 \qquad \sum_{i=1}^6N_i=6I_5,
 \qquad N_i^tG=GN_i.
\]

These are the coefficient-space versions of `i_Hq_H`.  In particular their
nonzero eigenvalue is five, agreeing with `q_Hi_H=[5]`; there is no projector
normalization hidden here.

## 2. Transport to the actual exotic principal lattice

Let `B` be the exact rational basis of the exotic principal homology lattice
constructed from the order-two `omega` graph and the selected order-three
graph.  Its denominator is six and

\[
 B\begin{pmatrix}0&G\\-G&0\end{pmatrix}B^t
\]

is unimodular.  Because the rows of `B` are principal-lattice vectors in
source coordinates, the transported integral matrices are

\[
 M_i=B\,\operatorname{diag}(N_i,N_i)^tB^{-1}\in M_{10}(\mathbf Z).
\]

The replay verifies integrality and all three norm identities after this
transport.  It then enumerates the 64 sums

\[
                         M_S=\sum_{i\in S}M_i
\]

over `F_2`.  The exact rank histogram is

| rank | number of subsets |
|---:|---:|
| 0 | 2 |
| 2 | 12 |
| 4 | 30 |
| 6 | 20 |

The two rank-zero subsets are the empty and full sets, as forced by
`sum M_i=0 mod 2`.  Complementary subsets give the same matrix, and every
subset of size at most three has rank twice its size.  Hence

\[
                         \det M_S\equiv0\pmod2
\]

for every `S`.  Since an arbitrary integral combination has the same mod-two
reduction as one of these 64 sums, this exhausts all integral linear
combinations, not only coefficients zero and one over `Z`.

If an invertible sum had existed, Cayley--Hamilton would have made
`adj(M_S)` an integral polynomial in `M_S`, and odd determinant `d` would
have yielded

\[
 \operatorname{adj}(M_S)M_S+\frac{1-d}{2}(2I)=I.
\]

The rank enumeration proves that this branch never starts.

## 3. The graph-transpose codimension check

Let `P subset S times X` be the universal family of lines.  It has codimension
two.  The transpose graph of `gamma_H:S->E_H` has codimension one in
`E_H times S`.  Correspondence composition gives

\[
 1+2-\dim S=1,
\]

so

\[
              P\circ\Gamma_{\gamma_H}^t\in CH^1(E_H\times X),
\]

not `CH^2(E_H times X)`.  It has the wrong Kunneth degree and cannot induce
the desired map `H^1(E_H)->H^3(X)`.

To obtain a curve correspondence from `E_H` to `S`, one must intersect the
graph with a divisor `D` on `S`:

\[
 T_D=\Gamma_{\gamma_H}^t\cdot p_S^*D
       \in CH^2(E_H\times S).
\]

Then `P o T_D` lies in `CH^2(E_H times X)`.  Let
`j_D:E_H->Alb(S)=J` be its induced Abel--Jacobi homomorphism.  Fibrewise
degree gives the exact identity

\[
                         q_Hj_D=[D\cdot F_H],
\]

where `F_H=sum_{g in H,o(g)=2}D_g` is a fibre of `gamma_H`.

For the canonical incidence divisor, Roulleau's intersection formula gives

\[
 C_s\cdot F_H=\sum_{g\in H}C_sD_g=5\cdot2=10.
\]

The correspondence is `D5`-equivariant.  The `D5`-fixed coefficient line in
the five-dimensional carrier is unique, so `j_{C_s}` lands in `i_H(E_H)`.
Since

\[
 q_Hi_H=[5],\qquad q_Hj_{C_s}=[10],
\]

one obtains, up to the common orientation sign,

\[
                         \boxed{j_{C_s}=2i_H}.
\]

Equivalently, the divisor `C_s` polarizes `Alb(S)` by twice the principal
form.  Indeed `a^*Theta=2C_s` and `[S]=Theta^3/3!` give

\[
 \int_S a^*\alpha\,a^*\beta\,C_s
   =\frac12\int_J\alpha\beta\frac{\Theta^4}{3!}
   =2\langle\alpha,\beta\rangle_\Theta.
\]

This independent calculation fixes the same factor two.

## 4. Exhausting all divisor cuts

Roulleau's exact Neron--Severi sequence is

\[
 0\longrightarrow NS(J)\xrightarrow{a^*}NS(S)
   \longrightarrow\mathbf Z/2\longrightarrow0,
\]

with the final class generated by `C_s`.

For `D in NS(J)`, let `N_D` be its Rosati endomorphism.  The fibre degree of
its restriction is

\[
 (a^*D)\cdot F_H
 =\operatorname{tr}(N_D)\operatorname{tr}(N_H)
   -\operatorname{tr}(N_DN_H).
\]

The replay evaluates this functional on the full rank-fifteen integral
`NS(J)` lattice of the actual exotic principal quotient and adjoins
`C_s.F_H=10`.  For every one of the six axes the resulting degree ideal is

\[
                         \{D\cdot F_H:D\in NS(S)\}=2\mathbf Z.
\]

It separately computes the saturated `D5`-fixed sublattice.  There the degree
ideal is

\[
              \{D\cdot F_H:D\in NS(S)^{D5}\}=10\mathbf Z.
\]

If a divisor cut lands purely on the marked axis, equivariance gives
`j_D=m i_H`, hence

\[
                         D\cdot F_H=5m.
\]

The fixed degree ideal forces `m` even.  Thus no divisor cut, including the
full saturated half-theta class, constructs primitive `i_H`.  Noninvariant
divisors can have degree two, but their correspondences have components in
the four-dimensional kernel and are not the pure axis map.

The precise remaining loophole is a genuinely non-divisor/non-Lefschetz
relative correspondence in `CH^2(E_H times S)`, or a direct relative cycle in
`CH^2(E_H times X)`, normalized to induce `i_H`.  The graph shortcut does not
provide one.

## 5. Replay

```sh
cd /home/tavis/src/othello
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-10-c904-six-axis-norm-mod2.sage").read()))'
```

The replay imports the task-owned exact principal-lattice constructor without
executing its main routine, transports the six norms, checks every algebraic
identity, enumerates all 64 mod-two combinations, reconstructs the full
integral Neron--Severi lattice, and computes both fibre-degree ideals.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-six-axis-norm-mod2.sage` | 9,133 | `534e9ecaad9d94e38676b9e6dc00d958d6ac78fbf897d532443051b4c4653cdb` |
| `notes/2026-08-10-c904-six-axis-norm-mod2.out` | 670 | `47cfe0cc653ef46628fa7aba99d96c3b7495ff2822608f6bc85bfd413567b842` |

## 6. Sources and boundaries

- X. Roulleau, *Genus 2 curve configurations on Fano surfaces*,
  arXiv:1002.4467, Theorem 11(D), Lemma 17 and the identical `D5` argument:
  the five-component fibre and elliptic quotient; the paper also gives
  `C_sD_g=2`.
- X. Roulleau, *Fano surfaces with 12 or 30 elliptic curves*,
  arXiv:1001.4855, Theorem 11: the exact `NS(J)->NS(S)` cokernel and incidence
  generator.
- Clemens--Griffiths, *The intermediate Jacobian of the cubic threefold*:
  the Fano Albanese/intermediate-Jacobian identification and universal-line
  Abel--Jacobi correspondence.
- `notes/2026-08-10-c904-annals-literature-red-team.md`: the exact
  `q_Hi_H=[5]`, off-axis `[-1]`, and `6I-J` polarization calculation.

The mod-two and divisor-lattice statements are exact integral calculations.
The correspondence sign depends only on the common Abel--Jacobi orientation
and does not affect the factor-two conclusion.  No claim is made that all of
`CH^2(E_H times S)` is divisor-generated.

## Mystery ledger

- **Settled:** no integral linear combination of the six `N_i` is invertible
  modulo two; maximum rank is six.
- **Settled:** the graph transpose alone has the wrong codimension.
- **Settled:** the canonical incidence repair induces `2i_H`, hence `2N_H`.
- **Settled:** every `D5`-equivariant divisor-cut repair is an even multiple
  of `i_H`; the exact fixed fibre-degree ideal is `10Z`.
- **Open:** a non-divisor relative correspondence inducing primitive `i_H`.
