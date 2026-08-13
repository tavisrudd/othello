# C907 monodromy-normalized Gamma/Orlov seed gate

**Lane:** `clebsch`

**Status:** source-audited partial result and hostile-reviewed comparison gap.
Iritani fixes the exact marked class in the global satellite block.  No theorem
yet transports that marked satellite generator to the bounded four-value
residual system, so the one-integer point-class shear remains open.

## Exact source-level seed

For the toric pilot

\[
\operatorname{Bl}_{\mathbf P^3}\mathbf P^5,
\]

Iritani's Theorem 7.31 identifies the exceptional satellite summand with the
Orlov block

\[
K(Z)_{-1}
=i_{E*}p_E^*K(Z)\otimes\mathcal O(-E).
\tag{1}
\]

In the proof, the positive-real thimble corresponds to $[\mathcal O]$.
Picard--Lefschetz continuation around the inverse exceptional loop
$t\mapsto e^{-i\theta}t$ constructs $\beta_1$ with

\[
\begin{aligned}
\beta_1
&\longleftrightarrow
[\mathcal O(E)]-[\mathcal O]\\
&=[i_{E*}\mathcal O_E(E)]
=[i_{E*}\mathcal O_E(-1)].
\end{aligned}
\tag{2}
\]

The typed equality follows from

\[
0\longrightarrow\mathcal O
\longrightarrow\mathcal O(E)
\longrightarrow i_{E*}\mathcal O_E(E)
\longrightarrow0
\tag{3}
\]

and $\mathcal O_E(E)\cong\mathcal O_E(-1)$ for a smooth blowup.  Base
Novikov monodromy generates the line-bundle orbit and hence the whole
$K(\mathbf P^3)$ block.  This settles the global satellite class, not its
identification with a separately localized four-thimble basis or its directed
ordering.

## Why literal path restriction fails

Iritani's satellite summands use satellite discs and strips which wind around
the origin and extend toward $\operatorname{Re}u\gg0$.  They are global
relative-homology data.  The C907 residual system instead becomes bounded only
after a parameter-dependent affine translation and $t^{-1/2}$ rescaling, and
is then cut out over a small four-value path neighborhood $\Omega$.

There is therefore no literal operation of restricting Iritani's strips to
$\Omega$.  The fibrewise collar/excision theorem, even after repair, would
identify an unmarked localized relative group.  It would not remember the
global satellite strip, its outgoing boundary condition, or the inverse-loop
normalization in (2).

The exceptional loop also acts on the chosen branch of $t^{1/2}$.  Without an
explicit continuation calculation it can permute or reorient the four
normalized values and their directed paths.  Thus neither the Beilinson order
nor the sign of its hyperplane orbit follows from generation of (1).

## Marked comparison theorem required

To remove the remaining centralizer shear, construct a natural integral map

\[
\operatorname{Lef}^{(-1)}_{\mathrm{sat}}
\longrightarrow
H_5\bigl(F_\delta^{-1}(\Omega),F_\delta^{-1}(u_0);\mathbf Z\bigr)
\tag{4}
\]

with all of the following properties.

1. Write the affine normalization $\Phi_t$ explicitly, including a base ray
   and a branch of $t^{1/2}$.
2. Track the satellite disc, each global strip, and its outgoing relative
   boundary condition under $\Phi_t$ and controlled excision.
3. Prove (4) is an integral isomorphism preserving boundary orientation and
   the directed Seifert form.
4. Continue $\Phi_t$ around $t\mapsto e^{-i\theta}t$ and compute the induced
   permutation and orientation of the four normalized values and paths.
5. Prove the resulting Gauss--Manin square intertwines Iritani's $\beta_1$
   relation (2) with the localized generator.
6. Specify the signed base-hyperplane loop and verify whether its directed
   orbit is ordered by $\mathcal O(i)$ or $\mathcal O(-i)$.

Only this marked satellite-to-localized theorem, together with the repaired
fibrewise collar theorem, can force the centralizer ambiguity

\[
1+c(1-x)^3
\tag{5}
\]

to have $c=0$.  Until then, the subgroup and the global seed class are exact,
but the individual localized basis retains the one-integer shear.

## Source audit

The load-bearing source is Hiroshi Iritani, *Global Mirrors and Discrepant
Transformations for Toric Deligne--Mumford Stacks*, arXiv:1906.00801,
SHA-256
`dc25e5cbd849ee5daa7643d69ae2e77936d5cd343ceb66ce8bbd8e03fbf874c7`,
1,915,714 bytes, 111 pages.  The exact class (2) is supported by Theorem 7.31,
its proof, and equation (7.24).  Theorem 7.33 controls continued sectorial
bases but does not identify an arbitrary localized basis with the satellite
one.  The new comparison demanded in (4) is not attributed to Iritani.

## EJ/TT and mystery ledger

- **EJ:** isolate the precise new map (4).  The K-theory seed does not need
  recomputation; the missing work is an integral, loop-equivariant
  satellite-to-localized excision theorem.
- **TT:** subgroup generation never fixes a directed basis.  Global satellite
  strips and bounded residual paths have different relative boundary data,
  so calling one a restriction of the other hides the entire marking problem.
- **Settled:** the exact typed global class
  $[i_{E*}\mathcal O_E(-1)]$ and generation of its Orlov block.
- **Refuted:** the claim that choosing Iritani's paths immediately forces
  $c=0$ in the localized system.
- **Open evidence gap:** the six-part marked comparison theorem above; the
  repaired algebraic and fibrewise collar gates on which it depends.
