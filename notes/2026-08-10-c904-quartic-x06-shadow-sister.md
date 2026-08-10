# C904: the $S_6$-quartic is the classical $X_0(6)$ shadow sister

Date: 2026-08-10  
Scope: high-EV mathematics, exact computation, and bounded priority audit.  No
manuscript or Lean source was edited.

Literature depth: one primary source was read in full and five were read
partially from their full PDFs at the sections stated in the source ledger.
The negative priority search is
bounded and is not publication-grade: MathSciNet, zbMATH, and a full
forward-citation closure remain uncovered.

## 1. Verdict

The highest-EV route is positive and does not require an exceptional-$E_6$
claim.

The intermediate Jacobians of the resolved $S_6$-invariant quartic
threefolds do not merely have rational type $E^5$.  Their integral symplectic
$S_6$ lattice is forced: it is the root--weight lattice underlying the
classical $A_5$ Weyl-family of principally polarized fivefolds.  Consequently
their nonconstant period locus is the whole modular curve $X_0(6)$.

This settles the open ``classical shadow sister'' gate in the prior C904
dossier at the level of polarized period loci.  It also places the quartic and
the $A_5$-cubic on the two branches already isolated over $X_0(3)$:

- the resolved $S_6$-quartic realizes the rational, degree-three $X_0(6)$
  branch;
- the $A_5$-cubic realizes one of the two exotic two-primary gluings, exchanged
  by the quadratic discriminant cover.

An exact admissible-cover calculation identifies the primitive cusp widths,
fixes the Hauptmodul, and gives an explicit degree-three map from the quartic
parameter to the cubic parameter.  At the ten-line boundary, its exotic
Petersen covers carry the same integral $6I-J$ lattice as the cubic's six
$D_5$ axes.

## 2. Integral rigidity theorem

Let

\[
 L=A_5=\{(x_1,\ldots,x_6)\in\mathbf Z^6:\sum x_i=0\},
 \qquad V=L\otimes\mathbf Q,
\]

with its standard $S_6$ action and dot product.  Write $L^\#$ for the weight
lattice.

### Theorem (standard-$S_6$ symplectic lattice rigidity)

Let $(\Lambda,\psi)$ be a unimodular symplectic lattice of rank ten with an
$S_6$ action such that

\[
 \Lambda_{\mathbf Q}\simeq V\oplus V
\]

as a rational $S_6$ module.  Then $(\Lambda,\psi)$ is $S_6$-equivariantly
symplectically isomorphic to

\[
 L\oplus L^\#
\]

with the standard root--weight symplectic pairing.  Relative to a chosen
root--root lattice $L\oplus L$, the twelve possible self-dual gluings form one
$\operatorname{SL}_2(\mathbf Z/6)$ orbit, and the stabilizer of one gluing in
$\operatorname{SL}_2(\mathbf Z)$ is $\Gamma_0(6)$.

### Proof

Put $U=\operatorname{Hom}_{S_6}(V,\Lambda_{\mathbf Q})$.  Absolute
irreducibility of $V$ and uniqueness of its invariant symmetric form give

\[
 \Lambda_{\mathbf Q}=V\otimes U,
 \qquad \psi=b\otimes\eta,
\]

where $b$ is the dot product on $V$ and $\eta$ is a nondegenerate alternating
form on the rational plane $U$.

Fix a root $\alpha=e_1-e_2$ and define

\[
 M=\{u\in U:\alpha\otimes u\in\Lambda\}.
\]

The roots are one $S_6$ orbit and generate $L$, so
$L\otimes M\subseteq\Lambda$.  Conversely, if $x\in\Lambda$, then for every
transposition $s_{ij}$,

\[
 (1-s_{ij})x=(e_i-e_j)\otimes u_{ij}\in\Lambda,
\]

and hence $u_{ij}\in M$.  In the six-coordinate model of $V\otimes U$, all
coordinate differences of $x$ therefore lie in $M$.  Since the coordinates
sum to zero, this is exactly the root--weight sandwich

\[
 L\otimes M\subseteq\Lambda\subseteq L^\#\otimes M. \tag{2.1}
\]

Choose two roots with dot product $-1$.  Integrality of $\psi$ on $\Lambda$
shows that $\eta(M,M)\subseteq\mathbf Z$.  Let $k\geq1$ be the elementary
divisor of this rank-two alternating lattice.  For
$B=L\otimes M$, the determinant formula for a tensor product gives

\[
 \lvert\det(\psi|_B)\rvert
   =\det(b|_L)^2\det(\eta|_M)^5
   =6^2k^{10}.
\]

Self-duality of $\Lambda$ therefore gives

\[
 [\Lambda:B]=6k^5. \tag{2.2}
\]

But (2.1) embeds $\Lambda/B$ in

\[
 (L^\#/L)\otimes M\simeq(\mathbf Z/6)^2,
\]

so $6k^5\leq36$.  Hence $k=1$.  Thus $M$ is symplectically unimodular,
$B^\#=L^\#\otimes M$, and $K=\Lambda/B$ is a maximal isotropic subgroup of
the discriminant plane $(\mathbf Z/6)^2$ of order six.

By the Chinese remainder theorem, such a $K$ is a line in
$\mathbf F_2^2$ together with a line in $\mathbf F_3^2$.  There are

\[
 (2+1)(3+1)=12
\]

choices.  They form one $\operatorname{SL}_2(\mathbf Z/6)$ orbit.  The
stabilizer of the standard line is $c\equiv0\pmod6$, namely
$\Gamma_0(6)$.  Choosing that line turns the corresponding overlattice into
$L\oplus L^\#$, proving the theorem.  $\square$

### Why this is stronger than the earlier rational statement

The rational decomposition $V\oplus V$ alone gives a one-dimensional period
domain and an $E^5$ isogeny.  It does not identify the principal polarization
or the arithmetic group.  The index squeeze

\[
 6k^5\leq36
\]

is the missing integral step: it forces the multiplicity lattice to be
unimodular and leaves exactly the twelve root/weight gluings whose stabilizer
is $\Gamma_0(6)$.

## 3. Geometric consequence for the quartic family

Cheltsov--Kuznetsov--Shramov construct the resolved $S_6$-quartic family and
record that its five-dimensional intermediate Jacobian has faithful $S_6$
action, standard-root rational cohomology of multiplicity two, and is isogenous
to $E(\lambda)^5$, with the elliptic $j$-invariant varying with the parameter.
The integral homology is unimodular symplectic by Poincare duality, so the
theorem applies fiberwise and locally in the variation.

Carocca--Gonzalez-Aguilera--Rodriguez prove that the principally polarized
Weyl family for $A_n$ is parameterized by
$\mathfrak H/\Gamma_0(n+1)$.  At $n=5$ this is $Y_0(6)$, with compactification
$X_0(6)$.  Therefore the quartic period map lands in this exact integral
family.  It is nonconstant by the varying-$j$ statement in the quartic paper;
its image closure is consequently the whole irreducible modular curve.

### Corollary (proved period-locus identification)

The closure of the intermediate-Jacobian period locus of the resolved
$S_6$-invariant quartic pencil is the classical $A_5$ Weyl curve $X_0(6)$.

This corollary identifies the locus; the boundary calculation below then
identifies the quartic parameter $t$ with a specified Hauptmodul.  A clean manuscript proof should make the family-level
local-system argument explicit rather than presenting the fiberwise lemma as
if it automatically chose a global marking.

## 4. Exact boundary arithmetic and the Hauptmodul

The quartic discriminant set is

\[
 D=\left\{\frac14,\frac12,\frac16,\frac7{10}\right\}.
\]

Its unordered cross-ratio orbit is

\[
 \left\{-8,-\frac18,\frac19,\frac89,\frac98,9\right\},
\]

exactly the cross-ratio orbit of the four cusps
$\{0,1,9,\infty\}$ in the previously normalized $X_0(6)$ coordinate $y$.
Thus the compactified quartic parameter line and $X_0(6)$ have the same
four-pointed moduli.

The three isolated additional node orbits have standard-carrier vectors

\[
 \begin{array}{c|c|c}
 t&\text{projective orbit}&\sum_v vv^{\mathsf T}\text{ on }V\\ \hline
 \frac12&\{\pm(e_i-e_j)\}_{15}&6I_V\\
 \frac16&\{\pm(1,1,1,-1,-1,-1)\}_{10}&12I_V\\
 \frac7{10}&\{(5,-1,-1,-1,-1,-1)\}_{6}&36I_V.
 \end{array}
\]

The frame constants are useful orbit checks, but they are **not** primitive
Picard--Lefschetz widths.  The admissible-cover calculation below instead
gives widths $6,3,2,1$ at $t=1/2,1/6,1/4,7/10$, respectively.  It therefore
fixes the Möbius coordinate

\[
 y(t)=-\frac{2t+1}{6t-1},
\]

with

\[
 \frac12\mapsto-1,\qquad
 \frac16\mapsto\infty,\qquad
 \frac14\mapsto-3,\qquad
 \frac7{10}\mapsto-\frac34.
\]

The earlier $X_0(6)\to X_0(3)$ root-cover formula

\[
 T=-\frac{(4y+3)(y+3)^2}{(y+1)^2}
\]

then gives the exact quartic-to-cubic shadow map

\[
 \boxed{
 T(t)=-\frac{80}{3}
 \frac{(t-\frac7{10})(t-\frac14)^2}
 {(t-\frac16)(t-\frac12)^2}.}
\]

In the Coble-cover coordinate $t=(\tau^2+1)/4$, this is

\[
 T(\tau)=-16
 \frac{\tau^4(5\tau^2-9)}
 {(3\tau^2+1)(\tau^2-1)^2}.
\]

The ramification has exactly the required $X_0(6)\to X_0(3)$ pattern:
$T=0$ has multiplicities $2,1$ at $t=1/4,7/10$, and $T=\infty$ has
multiplicities $1,2$ at $t=1/6,1/2$.

### Integral cusp calculation

The projective singular-point coordinates are not themselves integral
vanishing cycles, which is why the first frame heuristic gave the reverse
answer.  The correct calculation starts from the CKS map

\[
 s(\tau)=\frac{\tau^3-\tau}{5\tau^2+3},
 \qquad t=\frac{\tau^2+1}{4},
\]

identifies the four quartic degenerations with the three graph types of the
singular Wiman--Edge fibers:

- $t=1/4$ and $t=1/2$ both lie over $s=0$, whose ten-line dual graph is the
  Petersen graph; the two quartics select two different admissible double
  covers of that graph;
- $t=1/6$ lies over $s=\pm1/\sqrt{-3}$, whose five-conic dual graph is $K_5$;
- $t=7/10$ lies over $s=\pm1/\sqrt{125}$, whose irreducible six-nodal dual
  graph is one vertex with six loops.

For an admissible double cover, the principal Prym polarization is half the
Jacobian restriction, so its anti-invariant monodromy form is one copy of the
signed edge-square form.  The four primitive graph forms are

\[
\begin{array}{c|c|c}
t&\text{graph cover}&\text{primitive }X_0(6)\text{ width}\\ \hline
\frac7{10}&\text{six-loop rose}&1\\
\frac14&\text{$S_5$-fixed Petersen cover}&2\\
\frac16&\text{unique $A_5$-cover of $K_5$}&3\\
\frac12&\text{odd-conjugate Petersen pair}&6.
\end{array}
\]

At the Igusa point the graph computation is naturally over $\tau$, while
$t-1/4=\tau^2/4$; descent therefore halves the even $\tau$-variation form.
This produces the primitive width two rather than four.  CKS Corollary 4.9
also supplies the missing voltage discriminator: the $S_3$ line stabilizer
fixes the two ruling components at $\tau=0$ but swaps them at $\tau=\pm1$.
Thus $\tau=0$ is the unique $S_5$-fixed Petersen cover and $\tau=\pm1$ are
the odd-conjugate pair.

### TT3: the Petersen boundary already contains the cubic axis lattice

The finite part of that calculation is now exact.  Connected double covers
of the Petersen graph are classified by the nonzero classes in
$H^1(P,\mathbf F_2)$.  Direct integral enumeration gives

\[
 \left|H^1(P,\mathbf F_2)^{A_5}\right|=4.
\]

Thus there are exactly three connected $A_5$-equivariant covers.  Under the
residual odd permutation in $S_5$, one is fixed and the other two are
exchanged.  This is precisely the $1+2$ pattern over the CKS ten-line fiber:
$s^{-1}(0)=\{0,1,-1\}$, with $\tau=0$ fixed and $\tau=\pm1$ paired.  The
parameter match is promoted to a geometric identification by CKS Corollary
4.9: its trivial-versus-sign ruling character is exactly the fixed-versus-
swapped voltage character.

More importantly, take either member of the odd-conjugate pair.  Give every
edge of the graph cover norm one and take the anti-invariant signed-cycle
lattice, equivalently the toric character lattice with the usual Prym
half-polarization normalization.  An explicit unimodular basis change gives

\[
  \operatorname{Gram}(H_1(\widetilde P,\mathbf Z)^-)=6I-J
  =6A_5^\vee,
  \qquad \det=6^4.
\]

This is exactly the six-$D_5$-axis polarization lattice obtained independently
on the cubic side.  The $S_5$-fixed cover has determinant $1536$ instead and
is not in this integral isometry class.  Hence the exotic cubic lattice is
already present, without interpolation, in the Petersen boundary of the
classical quartic branch.  This is the first exact cross-family meeting found
at the integral boundary level rather than only on a common rational modular
curve.

The graph theorem, CKS ruling character, and the standard half-polarization
formula for an etale Prym together promote this lattice equality to the
quartic boundary.  In particular, the formula for $y(t)$ above is forced.
There is also a short degree-one argument.  The compactified period map is a nonconstant
map $\mathbf P^1\to X_0(6)\simeq\mathbf P^1$.  If the four points of $D$ are
proved to be exactly its cusp preimages, the four target cusps each have one
preimage.  A degree $d>1$ map would then be totally ramified over all four,
contributing $4(d-1)>2d-2$, contrary to Riemann--Hurwitz.  Hence $d=1$.
Beauville's full three-page argument proves that the desingularized
intermediate Jacobian is zero at the three isolated nodal values
$t=1/2,1/6,7/10$ (his reciprocal parameter is $2,6,10/7$).  Thus only the
Igusa semistable descent needed separate care; the even signed-cycle form and
the quadratic relation $t-1/4=\tau^2/4$ supply exactly that factor of two.

## 5. TT/EJ passes

### TT1: the Litt/$E_6$ musing

The C904 notation $E_6=\mathbf3\oplus\mathbf3'$ is a six-dimensional rational
$A_5$ constituent, not the exceptional group or root system.  It should be
renamed $U_6$ in future research notes to prevent a false inference.

There is nevertheless one exact restricted-$27$ observation.  The thirty
marked $(D_5,A_4)$ quotient pairs are canonically the ordered edges of the six
$D_5$ axes: their common involution lies in exactly one other $D_5$, and the
unique equivariant involution reverses the ordered edge.  The odd half of the
thirty-point permutation module is therefore
$\bigwedge^2\mathbf Q^6$, of dimension fifteen.  Together with the two rows of
six elliptic axes, this gives the restricted minuscule branching

\[
 27=(2\otimes6)\oplus\bigwedge^2 6=12+15.
\]

This is a genuine finite-carrier coincidence with the earlier Cartan model,
but there is no rank-27 geometric variation, flat exceptional tensor, or
monodromy mixing the two summands.  It is not presently an exceptional-$E_6$
theorem and was correctly deprioritized.

### EJ1: why the quartic gate is better

The root/weight index squeeze is short, conceptual, integral, and uniform in
the parameter.  It upgrades ``same rational representation'' to ``same
principally polarized modular curve.''  It also explains the number twelve of
integral gluings as

\[
 \lvert\mathbf P^1(\mathbf F_2)\rvert
 \lvert\mathbf P^1(\mathbf F_3)\rvert=3\cdot4.
\]

### TT2: strongest skeptic's objection

The theorem identifies a period **locus**, not a geometric correspondence.
The phrase ``quartic equals $X_0(6)$'' must
always mean its intermediate-Jacobian period curve.  It does not identify the
quartic threefold itself with a modular object.

### EJ2: the new series-level punchline

The C904 packet now has an unexpectedly symmetric pair:

- a classical $S_6$ threefold family forced onto the rational root/weight
  gluing of $X_0(6)$;
- an exotic $A_5$ cubic family forced onto the two non-$S_6$ gluings over the
  same $X_0(3)$ source.

This is stronger than two unrelated $E^5$ decompositions.  The loss of the odd
permutations is exactly the two-primary choice that moves from the classical
quartic shadow to the exotic cubic shadow.

## 6. Annals red team

### What is now theorem-grade

- the integral $S_6$ symplectic-lattice rigidity theorem;
- the $X_0(6)$ period-locus identification, subject only to spelling out the
  standard family-level transport;
- equality of the two unordered four-point cross-ratio orbits;
- the three exact tight-frame constants;
- the four primitive signed-cycle cusp forms and their widths;
- the unique Hauptmodul formula after that cusp labeling;
- the degree-three composition and its ramification algebra.

### What is not yet theorem-grade

- an integral correspondence between the quartic and cubic variations;
- finite-flat control at $2$ and $3$;
- extension across the boundary and the geometric realization of the Hecke
  relation;
- a publication-grade absence/priority verdict.

### Ceiling assessment

The period-locus and boundary theorem is genuinely new-looking and beautiful,
but by itself is more likely a strong specialist result than an Annals paper.
The top-tier package becomes plausible if the next step constructs the
relative geometric correspondence between the classical
quartic and exotic cubic branches, with boundary and two-primary behavior.

The highest-EV next move is therefore the relative correspondence, not a
further representation search.

## 7. Literature and priority boundary

Focused web searches on 2026-08-10 used the exact queries

```text
"S6-invariant quartic" "X_0(6)" intermediate Jacobian
"S6-invariant quartic" "Gamma_0(6)"
"Coble fourfold" "Weyl Groups and Abelian Varieties"
"intermediate Jacobian" "Gamma_0(6)" fivefold
"Coble fourfold, S6-invariant quartic threefolds" modular curve
"S6-invariant quartic threefolds" "Weyl groups" abelian varieties
"S_6-invariant quartics" intermediate Jacobian elliptic curve fifth power
"A5" "Gamma_0(6)" principally polarized abelian fivefold
"symplectic lattice" "root lattice" "weight lattice" S_n
"self-dual" "A_5" lattice S_6 symplectic
integral symplectic representations symmetric group standard lattice classification
S_n invariant lattices standard representation root weight lattice classification
```

No result located a direct connection between the $S_6$-quartic intermediate
Jacobian and the $A_5$ Weyl-family/$X_0(6)$.  The search did recover the quartic
paper and unrelated uses of $\Gamma_0(6)$.  This licenses only ``no direct
predecessor located in the bounded search.''  Google Scholar, MathSciNet,
zbMATH, systematic citation graphs, and the older integral representation
literature were not covered.

The closest additional source is Bernstein--Schwarzman, which the quartic
paper itself cites.  Its Theorem 3.1 classifies complex crystallographic
Coxeter groups.  In simply laced type $A_5$ its affine-root parameter is
$p=1$, so its modular ambiguity is $\Gamma_0(1)$; it neither imposes a
principal polarization on a rank-ten symplectic lattice nor produces the
root--weight discriminant gluing.  It supports the rational/unpolarized
$E^5$ mechanism but does not pre-empt the integral lemma above.

### Source ledger

- **Partial:** Ivan Cheltsov, Alexander Kuznetsov, and Constantin Shramov,
  *Coble fourfold, $S_6$-invariant quartic threefolds, and Wiman--Edge
  sextics*, arXiv:1712.08906, published in *Algebra & Number Theory* 14
  (2020).  Read from the cached full PDF: introduction and (1.3), Theorem
  1.14, Proposition 3.30, Sections 3.1 and 4.2, especially Corollary 4.9 and
  Remark 4.5.  Cache
  key `arXiv:1712.08906`; SHA-256
  `14c94b0b671cf5e172893086fed33f6600a593d74a5a83efda5384978022c598`.
- **Partial:** Angel Carocca, Victor Gonzalez-Aguilera, and Ruben E.
  Rodriguez, *Weyl Groups and Abelian Varieties*, arXiv:math/0503340.
  Read from the cached full PDF: the construction of the root/weight
  symplectic lattice and Section 5, especially Proposition 5.2 and Theorem
  5.4.  Cache key `arXiv:math/0503340`; SHA-256
  `c8e4287a8173c8b5f9ed80187f3463dedcd8a23edeb9d74964357b7eb117cf11`.
- **Full text:** Arnaud Beauville, *Non-rationality of the
  $S_6$-symmetric quartic threefolds*, arXiv:1212.5345v2, later published in
  *Rendiconti del Seminario Matematico, Universita e Politecnico di Torino* 71
  (2013).  Read in full from the cached three-page PDF; the closing remark
  proves that the desingularized intermediate Jacobian vanishes at the three
  isolated nodal parameters.  Cache key `arXiv:1212.5345`; SHA-256
  `15d2558f1a8ab2ec663f41275875b8e6b165dbbc0157c19acfce2f5f53e90210`.
- **Partial:** Joseph Bernstein and Ossip Schwarzman, *Complex
  crystallographic Coxeter groups and affine root systems*, *Journal of
  Nonlinear Mathematical Physics* 13 (2006), DOI
  `10.2991/jnmp.2006.13.2.2`.  Read from the cached full preprint: the
  classification statement and Sections 3.1--3.3, including Theorem 3.1 and
  the $p=1$ proof.  Cache key `10.2991/jnmp.2006.13.2.2`; SHA-256
  `bc43fc126db7d1fc30252a9088806dee54717aa5f28e9e3982e8a1f28f8cc816`.
- **Partial:** Benson Farb and Eduard Looijenga, *Arithmeticity of the
  monodromy of the Wiman--Edge pencil*, arXiv:1911.01210, later *Annales de
  l'Institut Fourier* 71 (2021).  Read from the cached full PDF: the
  degeneration summary, Sections 3.3 and 4.1, and especially Proposition 4.1
  and Remark 4.2.  Cache key `arXiv:1911.01210`; SHA-256
  `4de9866aaa1a4fd48cd0c532521962849ecbd4decab84f132a91720a4b5091fc`.
- **Partial:** Sebastian Casalaina-Martin, Samuel Grushevsky, Klaus Hulek,
  and Radu Laza, *Extending the Prym map to toroidal compactifications of the
  moduli space of abelian varieties*, arXiv:1403.1938, later *JEMS* 19
  (2017).  Read from the cached full PDF: Sections 3.3 and 4, especially
  Proposition 4.3 and Remark 4.4 on the anti-invariant graph character lattice
  and edge-square monodromy forms.  Cache key `arXiv:1403.1938`; SHA-256
  `6b5cda29ef536166280c508db27838844914ce2d652abfe0cbf3d808a9236ecd`.

The first source supplies the quartic geometry, rational $S_6$ type, and
nonconstant elliptic factor.  The second supplies the classical $A_5$
root/weight family and its $\Gamma_0(6)$ centralizer.  The integral rigidity
lemma connecting them is the present argument, not a claim made by either
source.

## 8. Reproducibility

Working directory:

```text
/home/tavis/src/othello
```

Primary replay:

```sh
python3 notes/2026-08-10-c904-quartic-shadow-modular.py --check
```

Independent replay, using pointwise rational interpolation and primitive
cyclic summands rather than the primary polynomial and CRT implementations:

```sh
python3 notes/2026-08-10-c904-quartic-shadow-modular-replay.py
```

Petersen boundary certificate and independent coset replay:

```sh
python3 notes/2026-08-10-c904-petersen-prym-boundary.py
python3 notes/2026-08-10-c904-petersen-prym-boundary-replay.py
```

Full four-cusp Prym certificate and independent admissible-cover replay:

```sh
python3 notes/2026-08-10-c904-quartic-prym-cusp-widths.py --check
python3 notes/2026-08-10-c904-quartic-admissible-cover-widths.py
```

The tracked certificates record the cross-ratio orbit, rational-map identity,
tight frames, twelve-gluing orbit, graph-cover classification, saturated
signed-cycle lattices, and their exact integral root--weight isometries.  The
CKS ruling-character identification and standard Prym polarization formula
remain human geometric inputs.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-quartic-shadow-modular.py` | 7941 | `253015daca31df1cdd11ecf8ce610af91041eea6074d6244ed514fed7ebe0be3` |
| `notes/2026-08-10-c904-quartic-shadow-modular-replay.py` | 3347 | `88b60840f5de5b7ec1515fd6b5ddefa4e743f608c8a3b18a7a9b317c096fe407` |
| `notes/2026-08-10-c904-quartic-shadow-modular.out` | 301 | `b0609450bb8fd6745f995dae3cea9a500bc7ea1ee450fc809eac4c0424b1442c` |
| `notes/2026-08-10-c904-petersen-prym-boundary.py` | 6451 | `759742c4ce666daea82972c038ecbd79bb60e7fa38992c9b6a14f03678a5cd2b` |
| `notes/2026-08-10-c904-petersen-prym-boundary-replay.py` | 2251 | `3c549a95fb582ee8a326c03515509fd4e765252767f51b7e633d613c05cee841` |
| `notes/2026-08-10-c904-petersen-prym-boundary.out` | 259 | `af04d7a5d9ef55d0e072c709ed408ec134e15b78937461a7c7f1f25ba879935a` |
| `notes/2026-08-10-c904-quartic-prym-cusp-widths.py` | 10744 | `5be0c8114acff7eadbd464d33868611088c332bbb2c3a40742f0b917863a6913` |
| `notes/2026-08-10-c904-quartic-prym-cusp-widths.out` | 591 | `0b16c98363c664095902c2685689b22bca2cbe7903f64ce3365bea39536601ef` |
| `notes/2026-08-10-c904-quartic-admissible-cover-widths.py` | 9178 | `cce8266832b245d05546aff72a649cf033db5ea57bc03dd8fbd1b56f0f60d2ff` |
| `notes/2026-08-10-c904-quartic-admissible-cover-widths.out` | 541 | `5db590ca5d3f622ca2b6b242b4a1dd3fb0b3c37b41f5661232d95ca5b575b131` |

## 9. Mystery ledger

- **Settled:** the C904 six-dimensional finite constituent is not exceptional
  $E_6$; rename it $U_6$ before any future promotion.
- **Settled:** the thirty marked quotient pairs do carry the restricted
  $12+15$ minuscule combinatorics, but no exceptional geometric variation has
  been constructed.
- **Settled:** the quartic's rational $A_5^{\oplus2}$ type has no hidden
  integral alternatives.  Unimodularity forces the root/weight gluing.
- **Settled:** the arithmetic group is $\Gamma_0(6)$ because the twelve
  gluings are the $3\cdot4$ local projective lines at two and three.
- **Settled:** the quartic discriminant divisor and the $X_0(6)$ cusps define
  isomorphic unordered four-pointed lines.
- **Settled:** the four primitive admissible-cover forms have widths
  $1,2,3,6$, fixing the displayed $y(t)$ and $T(t)$ formulas.
- **Settled, integral boundary theorem:** the Petersen graph has exactly three
  connected $A_5$-equivariant double covers, split as $1+2$ by $S_5$; each
  member of the pair has signed-cycle Gram lattice $6A_5^\vee=6I-J$, exactly
  the cubic six-axis lattice.  CKS Corollary 4.9 identifies the pair
  geometrically with the $\tau=\pm1$ covers.
- **Open, Annals gate:** build the relative algebraic correspondence between
  the classical quartic and exotic cubic branches and control its integral
  descent and boundary.
- **Open, priority gate:** complete MathSciNet/zbMATH and citation-graph
  closure before any manuscript novelty sentence.
