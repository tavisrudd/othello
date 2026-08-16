# Adversarial verification of the splitting-gauge isometry repair

date 2026-08-15, lane cubic-threefolds, task C912

Target: `notes/2026-08-15-c912-frame-transport-memo.tex`, Section `sec:rigid`
(Lemma `lem:decouple`, Lemma `lem:duality-gauge`, Theorem `thm:h2-automatic`,
Theorem `thm:no-irregularity`, Theorem `thm:rigidity`, Corollary
`cor:cubic-closed`), plus the weak-factorization correction in Section
`sec:unconditional`.

This report verifies the **current** argument: `lem:decouple` claims only
existence of a block-splitting gauge `g = I + O(z)`, states the freedom is
exactly composition with block-diagonal `k = I + O(z)`, and `lem:duality-gauge`
corrects `g` by such a `k` to make it an isometry, via the transported pairing
`Gt(z) := g(-z)^T G g(z)`. An earlier verification pass in this session covered
the withdrawn exponential/purely-off-block normalization; the parts of that pass
that survive (the `G`-block-diagonality result, the downstream analysis, the
cubic recomputation) are carried over below and re-scoped to the new argument.

Conventions used throughout: `A(z) = z^{-1}U - mu`, connection `z d_z Y = A Y`,
gauge action `g . A = g^{-1} A g - g^{-1} z d_z g`, bulk `nabla_a = d_a + z^{-1}C_a`,
flatness `d_a A = -z d_z C + [A, C]`, `B = Lambda[[tau]]` with `Lambda` a field of
characteristic zero.

## Verdict table

| # | Item                                                        | Verdict |
|---|-------------------------------------------------------------|---------|
| i   | Transported duality `At(-z)^T Gt + Gt At(z) + z d_z Gt = 0` | CORRECT — signs check, `z d_z` invariance checked |
| ii  | `Gt` is block diagonal                                      | CORRECT — no resonance; nilpotents are inside an invertible Sylvester operator, not "modulo" it. Memo's wording imprecise |
| iii | Block-diagonal correction `k` restoring `Gt -> G`           | CORRECT at every order — the induction closes, and for a cleaner reason than the memo gives. INCOMPLETE as written |
| 2   | `G` block diagonal over `B`, generalized eigenspaces        | CORRECT — and now free, as the `n = 0` case of (ii) |
| 7   | Downstream under the new (non-canonical) gauge              | MIXED — one INCORRECT statement survives in `lem:decouple`; the load-bearing chain survives; one new robustness fact is needed and missing |
| E   | `sec:unconditional` zigzag-not-roof correction              | CORRECT |

Overall: **`cor:cubic-closed` stands.** The new argument is correct and is a real
improvement on both withdrawn versions: it needs only existence of a splitting
gauge, so the false-uniqueness trap is gone entirely, and the isometry is
obtained by a construction (a twisted formal square root) rather than by a
rigidity claim.

## (i) The transported duality — CORRECT

Write `gbar(z) := g(-z)`, `Abar(z) := A(-z)`, `At := g . A`, `Gt := gbar^T G g`.

First the invariance claim. If `psi(z) = phi(-z)` then
`z d_z psi (z) = z · (-phi'(-z)) = (-z) phi'(-z) = (w d_w phi)(w)|_{w = -z}`. So
evaluation at `-z` commutes with `z d_z`, and in particular
`(z d_z g)(-z) = z d_z (gbar)` and `At(-z) = gbar . Abar`.

Now the computation, done independently:

    At(-z)^T = gbar^T Abar^T gbar^{-T} - (z d_z gbar)^T gbar^{-T}

    At(-z)^T Gt = [gbar^T Abar^T gbar^{-T} - (z d_z gbar)^T gbar^{-T}] gbar^T G g
                = gbar^T Abar^T G g - (z d_z gbar)^T G g

    Gt At(z)   = gbar^T G g [g^{-1} A g - g^{-1} z d_z g]
                = gbar^T G A g - gbar^T G (z d_z g)

Adding, the first pieces combine to `gbar^T [Abar^T G + G A] g`, which vanishes
by `eq:duality`. What is left is

    -[(z d_z gbar)^T G g + gbar^T G (z d_z g)]  =  -z d_z (gbar^T G g)  =  -z d_z Gt,

using the product rule, the `z`-independence of `G`, and
`z d_z (gbar^T) = (z d_z gbar)^T`. Hence `At(-z)^T Gt + Gt At(z) + z d_z Gt = 0`.

The memo's phrase "the two gauge terms combining into `z d_z Gt` exactly" is
precisely right; there is no stray sign. Also `Gt(0) = G` since `g(0) = I`.

## (ii) `Gt` is block diagonal — CORRECT, and the resonance worry does not arise

This is the step the coordinator flagged. Both worries are answered, and the
second one (a possible `(u_j - u_i + n)` resonance) is answered by the index
bookkeeping: the `z d_z Gt` term never multiplies `Gt_n`.

Write `At = z^{-1}U + At_0 + z At_1 + ...` (block diagonal, so `U` and every
`At_p` is block diagonal) and `Gt = sum_{n >= 0} z^n Gt_n`, `Gt_0 = G`. Collect
the coefficient of `z^{n-1}` in `eq:duality-transported`:

- from `-z^{-1}U^T · Gt`:      `-U^T Gt_n`
- from `Gt · z^{-1}U`:          `Gt_n U`
- from `sum_p (-1)^p z^p At_p^T · Gt`:  `(-1)^p At_p^T Gt_m`, `p + m = n-1`, so `m <= n-1`
- from `Gt · sum_p z^p At_p`:   `Gt_m At_p`, `p + m = n-1`, so `m <= n-1`
- from `z d_z Gt = sum_n n z^n Gt_n`:   `(n-1) Gt_{n-1}`

So the equation is

    T(Gt_n) = -[ (n-1) Gt_{n-1} + sum_{p+m=n-1} ( (-1)^p At_p^T Gt_m + Gt_m At_p ) ],
    T(Z) := Z U - U^T Z.

**The `z d_z` term lands on `Gt_{n-1}`, on the right-hand side, not on `Gt_n`.**
There is no `+n` added to the eigenvalue difference, hence no resonance question
at all, hence nothing to check about invertibility of `u_j - u_i + n` over `B`.
(Had the recursion been of that shape it would indeed have been a problem: `n` is
a nonzero integer of `Lambda` and `u_j - u_i` is a unit, but `u_j - u_i + n` is
in general neither, so the argument would have needed a genuine non-resonance
hypothesis. It does not.)

Now the off-block compression. For a bilinear form, the block components are
`Z_ij := P_i^T Z P_j`. Since `U` is block diagonal, `U P_j = P_j U P_j` and
`P_i^T U^T = P_i^T U^T P_i^T`, so

    T(Z)_ij = Z_ij U_j - Uhat_i Z_ij = (u_j - u_i) Z_ij + Z_ij N_j - Nhat_i Z_ij,

with `Uhat_i = P_i^T U^T P_i^T = u_i + Nhat_i`. The map
`Z -> Z N_j - Nhat_i Z` is a difference of two commuting nilpotent operators,
hence nilpotent; `(u_j - u_i)` is a unit by (H1). So `T_ij` is **invertible**,
with the nilpotent parts fully inside the operator. This is the point the memo
gets rhetorically wrong: it writes "`(u_j - u_i) Gt_ij = 0` modulo terms
involving the nilpotent parts and lower order", which reads as if the nilpotent
contributions were being discarded. They are not discarded and they need not be:
they are part of an invertible operator, exactly as in `lem:decouple`. The memo's
own next sentence ("This is the Sylvester argument already used in
Lemma `lem:decouple`") points at the right thing, so this is a wording defect,
not a mathematical one.

The induction. Assume `Gt_m` block diagonal for all `m < n`. Every right-hand
term then has vanishing `(i,j)` component for `i != j`: `(n-1) Gt_{n-1}` by
hypothesis; `P_i^T At_p^T Gt_m P_j = At_{p,i}^T (P_i^T Gt_m P_j) = 0`; and
`P_i^T Gt_m At_p P_j = (P_i^T Gt_m P_j) At_{p,j} = 0`. So
`T_ij(Gt_{n,ij}) = 0` and `Gt_{n,ij} = 0`.

Base case, checked explicitly. Order `z^{-1}`: `T(Gt_0) = 0`, i.e.
`G U = U^T G` — an identity, being exactly `G`-self-adjointness of `U`; its
off-block component gives `T_ij(G_ij) = 0`, so `G_ij = 0`. **The block
diagonality of `G` falls out of the same recursion at `n = 0`** and does not need
to be imported. Order `z^0`: `T(Gt_1) + At_0^T G + G At_0 = 0`, whose off-block
part is `T_ij(Gt_{1,ij}) = 0`. Order `z^1`: `T(Gt_2) + At_0^T Gt_1 + Gt_1 At_0 -
At_1^T G + G At_1 + Gt_1 = 0` — note the `Gt_1` at the end, which is the
`z d_z` contribution `(n-1)Gt_{n-1}` with `n = 2` — off-block part again
`T_ij(Gt_{2,ij}) = 0`. Closes.

## Item 2, carried over: `G` is block diagonal — CORRECT

Still used by the memo (in (iii), and in the "restriction to a block is
legitimate" sentence). Independently of (ii)'s `n = 0` case, two proofs, both
valid over `B` and for *generalized* eigenspaces:

(a) `U^T G = G U` implies `(U^T)^k G = G U^k`, and the spectral idempotents are
polynomials in `U` over `B` (Hensel over the complete local ring `B`, lifting the
separated spectral clusters of `U(0)` that (H1) provides, then CRT). So
`P_i^T G = G P_i`, and `P_i^T G P_j = G P_i P_j = 0` for `i != j`.

(b) Without idempotent lifting: for `x` in `H_i` choose `k` with `(U-u_i)^k x = 0`;
then `0 = ((U-u_i)^k x, y) = (x, (U-u_i)^k y)` for `y` in `H_j`, and
`(U-u_i)|_{H_j} = (u_j-u_i) + N_j` is a unit plus a nilpotent, hence invertible.

Consequences used later: `G` commutes with every `P_i`; `P_i^T = G P_i G^{-1}`;
`det G_i` is a unit, so `G` restricts nondegenerately to each block.

## (iii) The block-diagonal correction — CORRECT at every order

**Symmetry pattern.** `Gt(z)^T = (gbar^T G g)^T = g^T G^T gbar = g(z)^T G g(-z)`,
which is `Gt(-z)` read off the definition. Using `G^T = G`. Hence
`Gt_n^T = (-1)^n Gt_n`: even coefficients symmetric, odd antisymmetric,
`Gt_0 = G` symmetric. Verified.

**Order 1.** With `H(z) := k(-z)^T Gt(z) k(z)` and `k = I + z k_1 + ...`,
`H_1 = Gt_1 - k_1^T G + G k_1`. Put `M = G k_1`; then `k_1^T G = k_1^T G^T =
(G k_1)^T = M^T`, so `H_1 = Gt_1 + M - M^T`. Setting `H_1 = 0` gives
`M - M^T = -Gt_1`, and since `Gt_1` is antisymmetric, `M = -Gt_1/2` solves it
(`M - M^T = -Gt_1/2 + Gt_1^T/2 = -Gt_1`). `k_1 = G^{-1}M` is block diagonal
because `G` and `Gt_1` are. Verified, matching the memo.

**Order 2, explicitly.** Expanding `H = sum_{a,b,c} (-1)^a z^{a+b+c} k_a^T Gt_b k_c`
with `k_0 = I`, the `z^2` coefficient is

    H_2 = Gt_2 + Gt_1 k_1 - k_1^T Gt_1 - k_1^T G k_1 + G k_2 + k_2^T G
        = Omega_2 + M_2 + M_2^T,     M_2 := G k_2.

Solvability needs `Omega_2` symmetric. Check term by term: `Gt_2^T = Gt_2`;
`(Gt_1 k_1 - k_1^T Gt_1)^T = k_1^T Gt_1^T - Gt_1^T k_1 = -k_1^T Gt_1 + Gt_1 k_1`,
the same expression; `(-k_1^T G k_1)^T = -k_1^T G k_1`. So `Omega_2` is symmetric
and `M_2 = -Omega_2/2` solves `M_2 + M_2^T = -Omega_2`.

**Order 3, explicitly.**

    Omega_3 = Gt_3 + (Gt_2 k_1 - k_1^T Gt_2) + (Gt_1 k_2 + k_2^T Gt_1)
              - k_1^T Gt_1 k_1 + (k_2^T G k_1 - k_1^T G k_2),
    H_3 = Omega_3 + M_3 - M_3^T,   M_3 := G k_3.

Solvability needs `Omega_3` antisymmetric. Term by term: `Gt_3^T = -Gt_3`;
`(Gt_2 k_1 - k_1^T Gt_2)^T = k_1^T Gt_2 - Gt_2 k_1`, the negative;
`(Gt_1 k_2 + k_2^T Gt_1)^T = k_2^T Gt_1^T + Gt_1^T k_2 = -(Gt_1 k_2 + k_2^T Gt_1)`;
`(-k_1^T Gt_1 k_1)^T = +k_1^T Gt_1 k_1`, the negative;
`(k_2^T G k_1 - k_1^T G k_2)^T = k_1^T G k_2 - k_2^T G k_1`, the negative. So
`Omega_3` is antisymmetric and `M_3 = -Omega_3/2` solves it.

**General order — the induction really closes, for a reason the memo does not
give.** The clean statement is that the alternation is not something to be
re-checked at each order: the identity

    H(z)^T = k(z)^T Gt(z)^T k(-z) = k(z)^T Gt(-z) k(-z) = H(-z)

holds for **any** `k` whatsoever, given only `Gt(z)^T = Gt(-z)`. Hence
`H_n^T = (-1)^n H_n` identically in the `k_m`. Now let `k_1, ..., k_{n-1}` be
chosen so that `H_1 = ... = H_{n-1} = 0`, and let `Omega_n` be the order-`n`
coefficient computed with `k_n` (and higher) set to zero. `Omega_n` is `H_n` for
that truncated `k`, so `Omega_n^T = (-1)^n Omega_n` **automatically**, with no
term-by-term check. Splitting off the `k_n` contribution,

    H_n = Omega_n + G k_n + (-1)^n k_n^T G = Omega_n + M_n + (-1)^n M_n^T.

For `n` even, `M_n + M_n^T` ranges over symmetric matrices and `Omega_n` is
symmetric; for `n` odd, `M_n - M_n^T` ranges over antisymmetric matrices and
`Omega_n` is antisymmetric. In both cases `M_n = -Omega_n/2` solves it, and
`k_n = -G^{-1} Omega_n / 2` is block diagonal because `G`, every `Gt_m` (by (ii)),
and every `k_m` with `m < n` are.

So the memo's asserted "the obstruction at order `n` being symmetric or
antisymmetric exactly as required" is **true**, and it has a one-line reason that
should be written down, since as it stands it reads as an unchecked hope. Note
the construction needs characteristic not 2 (the `1/2`), which is available.

Finally, replacing `g` by `gk` keeps it block-splitting (`lem:decouple`'s freedom
statement) and gives `(gk)(-z)^T G (gk)(z) = k(-z)^T Gt(z) k(z) = G`. With
`Gt = G` constant, `z d_z Gt = 0` and `eq:duality-transported` collapses to
`At(-z)^T G + G At(z) = 0`, which is `eq:duality` for the decoupled connection.
Restriction to a block is then legitimate: `At` and `G` are both block diagonal
and `G` restricts nondegenerately. `eq:parity` follows coefficient by
coefficient, and I re-derived it: the `z^{-1}` coefficient gives `N^T G_0 = G_0 N`
and the `z^p` coefficient gives `(A_p')^T G_0 = (-1)^{p+1} G_0 A_p'`, as printed.
The `exp(u_0/z)` twist subtracts `z^{-1} u_0 I`, which is `sigma`-fixed
(`-G^{-1}(c(-z)^{-1}I)^T G = c z^{-1} I`), so it does not disturb `eq:duality`.

## 7. Downstream, under the new non-canonical gauge

### 7a. `lem:decouple`'s second claim is still INCORRECT as stated

Unchanged from the previous version of the lemma and still present verbatim.

Claim: "In the gauged frame the bulk connection is block diagonal as well".
Proof step: "Its off-block part in bidegree `(i,j)`, `i != j`, has zero left side
because `Atilde` is block diagonal."

That step is false. The projectors `P_i` depend on `tau`, so `d_a Atilde` is not
block diagonal: from `d_a(P_i Atilde P_j) = 0`,

    P_i (d_a Atilde) P_j = Y_ij Atilde_j - Atilde_i Y_ij,   Y_ij := P_i (d_a P_j) P_j,

which is `O(z^{-1})` and generically nonzero — at order `z^{-1}` it is
`(d_a U)_ij = C_{a,i} mu_ij - mu_ij C_{a,j}`, exactly the quantity
`thm:block-evolution` computes and does not set to zero.

Redoing the expansion with the `Y_ij` kept: put
`Delta := z^{-1}(Ctilde_a)_ij + Y_ij`. The flatness identity collapses to
`-z d_z Delta + Atilde_i Delta - Delta Atilde_j = 0`, whose order-by-order
Sylvester recursion forces `Delta = 0`. So the true statement is

    (Ctilde_a)_ij = -P_i (d_a P_j) P_j    for i != j,   z-independent,

i.e. the off-block part of the gauged bulk connection is exactly minus the Kato
transport, and `d_a + Ctilde_a` preserves each `H_i` **as a subbundle** without
being block diagonal as a matrix. It is covariantly block diagonal.

Impact: none on the chain. Step 4 already uses the correct object — it picks a
frame `(e_1, e_2)` of `H_0` over `B` and carries a frame connection `Gamma_a`,
with `k_a = (Ccheck^{(1)}_{a,0} + Gamma_a)_{21}`. The off-block part of
`Ctilde_a` cancels the off-block part of `d_a e_k` term by term, by the identity
just derived, so the restricted `2x2` pair is genuinely flat and
`eq:flat-pair` applies to it. Only the lemma's wording and that one proof
sentence need repair.

The lemma's other second-statement claim is correct: `Ccheck_a = g^{-1} C_a g +
z g^{-1} d_a g`, so `Ccheck^{(0)} = C_a` exactly and its `H_0` block is
`P_0 C_a P_0`; "since `g = I + O(z)`, the leading term is unchanged" is right and
is insensitive to which splitting gauge is used.

### 7b. Nothing else breaks, but one robustness fact is now needed and missing

The new gauge is explicitly **not canonical**: after the isometry correction the
residual freedom is the block-diagonal `k = I + O(z)` satisfying
`k(-z)^T G k(z) = G`. At order `z` that condition reads `G k_1 = (G k_1)^T`, i.e.
`k_1` is `G`-self-adjoint. Under such a `k`, `A_0' -> A_0' + [N, k_{1,0}]`, and
since `N` and `k_{1,0}` are both `G_0`-self-adjoint their commutator is
`G_0`-anti-self-adjoint — so `eq:parity` is preserved, as it must be. Consistent.

But `cor:cubic-closed` quotes specific numbers (`D_0 = diag(-19/18, 19/18)`,
`(A_1')_{21} = -8/81`, `nu = 2`) that are computed in *some* splitting gauge and
*some* block frame. Because the gauge is no longer pinned, the memo owes a
sentence saying the quoted characteristic polynomial does not depend on those
choices. It is true, and here is the argument:

- Under `g -> g k`, `k = I + z k_1 + ...` block diagonal, the shear-conjugate
  `S^{-1} k S` is *regular* at `z = 0`: the `(2,1)` entry of `z^n k_n` becomes
  `z^{n-1}` with `n >= 1`. Its `z^0` part is `I + (k_1)_{21} E_{21}`, invertible.
  A regular invertible gauge changes the residue of a regular-singular connection
  by conjugation only, so `char(R)` is invariant.
- The same covers the frame freedom `e_1 -> lambda e_1`, `e_2 -> rho e_2 + beta e_1`:
  `S^{-1} T S` is regular with invertible `z^0` part `diag(lambda, rho)`.
- Consistency: `f = (A_0')_{21}` is itself invariant, since `[N, k_1]_{21} = 0`
  for `N = nu E_{12}` and any `k_1`. Good, because `thm:h2-automatic` proves
  `f = 0` with no reference to a normalization.

Without this, a reader is entitled to ask why `-8/81` is a well-defined input.
Add it as a remark after `eq:sheared-data`.

### 7c. `thm:block-evolution`, `lem:commutant`, `thm:no-splitting` — unaffected

`thm:block-evolution` runs in the Kato frame with
`D_a A_i = P_i(d_a A)P_i + P_i[A, T_a]P_i` and uses only `[U, C_a] = 0` and
`d_a U = C_a + [C_a, mu]`. It never invokes `lem:decouple`, so nothing about the
splitting gauge reaches it. `lem:commutant` and `thm:no-splitting` inherit this.

### 7d. Step 4 shearing and Steps 6-7 — re-derived, correct

`S = diag(1,z)` sends `E_12 -> z E_12`, `E_21 -> z^{-1}E_21`, fixes diagonals,
`-S^{-1} z d_z S = -diag(0,1)`. Feeding `z^{-1}N + A_0' + z A_1' + ...` with
`N = nu E_12` gives `A_{-1} = (A_0')_{21} E_21` and
`A_0 = nu E_12 + diag((A_0')_{11}, (A_0')_{22} - 1) + (A_1')_{21} E_21`, i.e.
`eq:sheared-data` verbatim. In `thm:no-irregularity`,
`ad_R(E_21) = [[nu, 0], [delta - alpha, -nu]]` is right and the `z^{-1}`
coefficient balance is right. In `thm:rigidity`, the `z^0` coefficient of
`eq:flat-pair` is `d_a A_0 = [A_{-1}, H_a] + [A_0, G_a] + [A_1, K_a]` (the
`-z d_z Ctilde` contribution vanishes at `z^0`), collapsing to
`d_a R = [R, G_a]` once `A_{-1} = 0` and `K_a = 0`.

`thm:h2-automatic` itself: `N` `G_0`-self-adjoint and `N^2 = 0` give
`(Nx, Ny) = (x, N^2 y) = 0`, so `im N` is isotropic and `(e_1, e_1) = 0`;
nondegeneracy makes `(e_1, e_2)` a unit; `A_0'` anti-self-adjoint for a symmetric
form gives `(A_0' x, x) = 0` (characteristic zero), and `x = e_1` yields
`f (e_2, e_1) = 0`, hence `f = 0`. Correct.

## Independent recomputation of the cubic block

This is the strongest available check, and it passes exactly. It is independent
of which splitting gauge the memo settles on, because it verifies the *parity
rules* `eq:parity` directly — the only thing `thm:h2-automatic` consumes — in the
gauge that reproduces the draft's numbers.

Reconstructing the small quantum product of a smooth cubic threefold from the two
matrix entries the memo quotes (`U_{21} = 2`, `U_{12} = 12q`) plus the
requirement that `U = 2(P star)` have spectrum `{0, 0, ±6r}`, `r^2 = 3q`, pins it
uniquely in the basis `(1, P, P^2, P^3)`:

    P*P = P^2 + 6q,   P*P^2 = P^3 + 15qP,   P*P^3 = 6qP^2 + 36q^2.

Then `M := P star` has `M^2|_{span(1,P^2)} = [[6q, 126q^2],[1, 21q]]`, trace
`27q`, determinant `0`, so `M` has spectrum `{0, 0, ±3r}` and `U = 2M` has
`{0, 0, ±6r}`, matching (H1) and the draft's `K_0`. The zero generalized
eigenspace comes out as the memo states:

    e_1 = P^3 - 6qP,   e_2 = P^2 - 21q,   N e_1 = 0,  N e_2 = 2 e_1  (so nu = 2),

and the `±6r` eigenvectors are `f_± = w_o ± 3r w_e`, `w_o = P^3 + 21qP`,
`w_e = P^2 + 6q`.

**`A_0'`.** With `mu = diag(-3/2, -1/2, 1/2, 3/2)` and `P_0` read off the above:

    mu e_1 = (19/18) e_1 + (4/9) w_o    =>  mu_0 e_1 =  (19/18) e_1
    mu e_2 = -(19/18) e_2 + (14/9) w_e  =>  mu_0 e_2 = -(19/18) e_2

so `-mu_0 = diag(-19/18, 19/18)`, **exactly the draft's `D_0`**, and
`f = (A_0')_{21} = 0` is confirmed directly, independently of
`thm:h2-automatic`. (In a splitting gauge whose first-order generator is purely
off-block, `A_0' = -mu_0` on the nose; a general splitting gauge adds
`[N, k_1]`, which cannot change `f`.)

**`A_1'`.** From `Atilde_1 = [U, g_2] - mu g_1 - g_1 Atilde_0 - g_1`, block-0
part, using `S_{j0}^{-1} = u_j^{-1}(I + R_N/u_j)` and
`S_{0j}^{-1} = -u_j^{-1}(I + L_N/u_j)` (both exact, since `N^2 = 0`):

    (X_1)_{+0} = ( 1/(27r),  1/(18r^2) )      (X_1)_{0+} = ( -1/(3r), -2/9 )^T
    (X_1)_{-0} = ( -1/(27r), 1/(18r^2) )      (X_1)_{0-} = (  1/(3r), -2/9 )^T

giving `(X_1^2)_{00} = -(2/(81 r^2)) I`, a scalar, so its commutator with `N`
vanishes, and

    sum_j mu_{0j}(X_1)_{j0} = [[0, 14/(81 r^2)], [8/81, 0]],
    A_1' = -[[0, 14/(81 r^2)], [8/81, 0]],   (A_1')_{21} = -8/81.

**Exactly the draft's `-8/81`.** Hence `R = [[-19/18, 2], [-8/81, 1/18]]`,
`tr R = -1`, `det R = 5/36`, characteristic polynomial `rho^2 + rho + 5/36`,
roots `-1/6, -5/6`, monodromy eigenvalues `e^{∓ pi i/3}`, `nu_6 = 2`. Every
number in `eq:sheared-data` and `cor:cubic-closed` reproduces from scratch.

**`eq:parity` verified numerically.** The Gram matrix on `(e_1, e_2)` is
`G_0 = -81q · [[0,1],[1,0]]`; in particular `(e_1, e_1) = 0`, confirming the
isotropy input to `thm:h2-automatic`. Then

- `N^T G_0 = G_0 N` — `N` is `G_0`-self-adjoint. Holds.
- `(A_0')^T G_0 = -G_0 A_0'` — anti-self-adjoint. Holds for `diag(-19/18, 19/18)`.
- `(A_1')^T G_0 = +G_0 A_1'` — self-adjoint. Holds, `A_1'` being antidiagonal
  with zero diagonal.

So the *conclusion* of `lem:duality-gauge` is confirmed in the case that
carries the corollary, by explicit computation rather than by the lemma. This
also shows the isometry correction is doing real work: a general block-diagonal
regauge adds `[N, k_1] = 2·[[(k_1)_{21}, (k_1)_{22} - (k_1)_{11}], [0, -(k_1)_{21}]]`
to `A_0'`, which is `G_0`-anti-self-adjoint only when `(k_1)_{11} = (k_1)_{22}` —
equivalently only for the `k_1` that the isometry condition allows. A splitting
gauge chosen with no regard for the pairing does break `eq:parity`.

## E. The `sec:unconditional` weak-factorization correction — CORRECT

The corrected text says: (a) Abramovich-Karu-Matsuki-Włodarczyk gives a zigzag of
blowups and blowdowns along smooth centres, not a roof; (b) a common resolution
exists, but the assertion that *each* of the two descending arrows factors into
smooth blowups is strong factorization, open in the dimension at issue;
(c) therefore some blowup must be traversed upward, which is where the change of
variables would have to be inverted; (d) the endpoint reduction is conditional on
strong factorization or on an independent treatment of the upward steps.

All four are accurate.

- Weak factorization is exactly a zigzag `X = X_0 --> ... --> X_n = Y` with each
  arrow a blowup or blowdown along a smooth centre. It does not produce a variety
  dominating both ends through smooth blowups.
- Strong factorization is classical for surfaces and open from dimension three
  on; the case at issue is dimension four, so "open in the dimension at issue" is
  right.
- The half-roof point is stated correctly and is worth keeping: resolving the
  graph does give one arm `V -> X` as a composition of smooth blowups (Hironaka
  principalization), but the other arm `V -> Y` is only a birational projective
  morphism. The memo's "each of the two descending arrows" is the precise phrase.
- The diagnosis is right for this memo's formulation. The chemical-formula ledger
  is an identity in a free abelian group and is direction-blind; direction starts
  to matter only once explicit bulk parameters are tracked, which is what the
  endpoint reduction does. The comparison isomorphism
  `QDM(Bl_Z T) ≅ QDM(T) ⊕ QDM(Z)^{c-1}` is stated after a change of variables
  from the blowup-side parameter to the base-side parameters, so prescribing the
  base parameter and solving for the one upstairs is inversion of that map — the
  move `sec:unconditional` already refuted.

One caveat on strength: "one must traverse some blowup in the upward direction"
is a statement about a general zigzag, not a theorem about every conceivable one;
an all-downward zigzag would be a smooth-blowup domination and is not available
in general. The memo's conditional framing already accommodates this.

Residual stale text elsewhere, not part of this correction: Section "Routes"
still says "the endpoint theorem is proved in Section `sec:endpoint`", while
`thm:endpoint` there is explicitly conditional on `nu_6` being constant on
connected components. That sentence should be softened.

## Overall verdict

`cor:cubic-closed` stands.

The new `lem:duality-gauge` is correct at every step I could check: the
transported duality (i) is a clean identity with no sign slip and the two gauge
terms really do assemble into `z d_z Gt`; the block diagonality (ii) closes by a
Sylvester recursion in which the nilpotent parts sit *inside* an invertible
operator and in which the `z d_z` term lands one order down, so the feared
`(u_j - u_i + n)` resonance never arises; and the correction (iii) exists at every
order, with the parity of the order-`n` obstruction automatic from
`H(z)^T = H(-z)`. It is a better argument than either withdrawn version: it needs
only existence of a splitting gauge, and it constructs the isometry instead of
claiming it.

Defects to fix, none of them breaking the chain:

1. `lem:decouple`, second statement and proof. "The bulk connection is block
   diagonal" is false as stated, and "zero left side because `Atilde` is block
   diagonal" is a false step, since `d_a P_i != 0`. The true statement is that the
   off-block part of the gauged bulk connection equals `-P_i(d_a P_j)P_j`,
   `z`-independent, so the connection preserves each `H_i` as a subbundle. Step 4
   already uses the true version; only the lemma needs repair.
2. `lem:duality-gauge` (ii): "modulo terms involving the nilpotent parts and lower
   order" understates the argument and reads like a discard. Say instead that
   `Z -> (u_j - u_i)Z + Z N_j - Nhat_i Z` is a unit plus a nilpotent, hence
   invertible. Worth adding that the `n = 0` case *is* the block diagonality of
   `G`, which the proof separately imports two paragraphs later.
3. `lem:duality-gauge` (iii): the general-order induction is asserted. Add the
   one-line reason — `H(z)^T = H(-z)` holds for any `k`, so the order-`n`
   obstruction has parity `(-1)^n` automatically — and note the `1/2` needs
   characteristic not 2.
4. Add a remark after `eq:sheared-data` that `char(R)` does not depend on the
   choice of splitting gauge or block frame, since the gauge is now explicitly
   non-canonical and the corollary quotes gauge-computed numbers. The proof is
   that `S^{-1} k S` is regular and invertible at `z = 0` for block-diagonal
   `k = I + O(z)`, so the residue changes only by conjugation.
