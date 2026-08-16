# Hostile referee report on Section 10 (`sec:unconditional`) of the frame-transport memo

Target: `notes/2026-08-15-c912-frame-transport-memo.tex`, Section "The endpoint,
unconditionally" (lines 1811-1960), with secondary passes on Section 8
(`sec:rigid`) and Section 9 (`sec:endpoint`).

Sources consulted (all local text extractions, line numbers refer to those files):

- `I-Bl` = `/tmp/persistent/tavis/lit-search/text/arXiv_2307.13555.txt` (Iritani,
  *Quantum cohomology of blowups*)
- `IK` = `/tmp/persistent/tavis/lit-search/text/arXiv_2307.03696.txt`
  (Iritani-Koto, *Quantum cohomology of projective bundles*)
- `KKPY` = `/tmp/persistent/tavis/lit-search/text/arXiv_2508.05105.txt`
  (Katzarkov-Kontsevich-Pantev-Yu)
- `Cai3` = `/tmp/persistent/tavis/lit-search/text/arXiv_2608.01577.txt` (Cai, cubic threefold)
- `Cai4` = `/tmp/persistent/tavis/lit-search/text/arXiv_2605.29143.txt` (Cai, quartic threefold)

---

## Verdict

**FATAL.** Theorem `thm:endpoint-unconditional` is not proved. The parameter
`\widetilde\tau_0` demanded in its proof (memo line 1906-1907, "let
$\widetilde\tau_0$ be the parameter with
$\varsigma_0(\widetilde\tau_0)=\varsigma_1(\widetilde\tau_0)=0$") does not exist,
and the sentence on which the whole section rests --- "all displacements are
topologically nilpotent in the Novikov directions ... the correspondence is a
bijection of formal germs in both directions" (memo lines 1840-1843) --- is
contradicted by the pinned sources in two independent ways: the displacement is
not topologically nilpotent (Iritani's Remark 1.3), and Iritani states in so many
words that the pullback of *functions* along the change of variables is
**ill-defined** (I-Bl, text after (5.19)). The section's own escape hatch, that
the string and divisor equations dispose of the $H^0$ and $H^2$ parts of the
displacement, is the very mechanism Iritani invokes to make the *forward*
pullback of connections legal, and there is no analogue of it for the inverse
direction that Section 10 needs.

(Details below; this file was written incrementally and later sections refine
the earlier ones.)

---

## FATAL findings

### F1. The displacement is not topologically nilpotent; the ring is completed in $Q$ and $\widetilde\tau$ only

Memo line 1840-1843:

> Since all displacements are topologically nilpotent in the Novikov directions,
> translation is an automorphism of the formal bulk germ, and the correspondence
> is a bijection of formal germs in both directions.

The displacement is *not* in the Novikov directions at all. By Iritani's own
Theorem 5.18(6) (I-Bl line 5661):

> $\tau(\tilde\tau)|_{Q=\tilde\tau=0} = q^{-1}[Z]+O(q^{-2})$ and
> $\varsigma_j(\tilde\tau)|_{Q=\tilde\tau=0} = -(r-1)\lambda_j+h_{Z,j}+O(q^{-1/(r-1)})$

with $\lambda_j=e^{-2\pi i(j+r/2)/(r-1)}q^{1/(r-1)}$ (I-Bl line 5688) and
$h_{Z,j}=\frac{2\pi i}{r-1}(j+\tfrac12)\rho_Z$ (I-Bl (5.19), line 4300). Every
term here is $Q$-free. The projective-bundle case, which is the one the memo's
final step actually uses, is Iritani-Koto Theorem 5.1(4) (IK line 2382):

> $\varsigma_j(\hat\tau)|_{Q=\hat\tau=0}=r\lambda_j-2\pi\sqrt{-1}\,j\,c_1(V)+O(q^{-1/r})$,
> with $\lambda_j=e^{2\pi\sqrt{-1}j/r}q^{1/r}$ (IK line 2354).

For $X\times\mathbf{P}^1=\mathbf{P}(\mathcal O^{\oplus2})$ over $B=X$ we have $r=2$,
$c_1(V)=0$, so $\varsigma_j^\circ=\pm2q^{1/2}+O(q^{-1/2})$: an $H^0$ term that is
a **positive** power of $q$, no $H^2$ term, and a tail in negative powers of $q$
in $H^{\ge4}$. The memo itself concedes the tail is unavoidable here (memo lines
771-774).

Now the topology. Iritani, Remark 1.3 (I-Bl lines 112-115):

> Throughout the paper, we work with completions in the category of graded rings
> or modules. ... For example, $\mathbf{C}((q^{-\frac1{r-1}}))[[Q]]$ is the same as
> $\mathbf{C}[q^{\pm\frac1{r-1}}][[Q]]$ since $q$ has positive degree.

and §2.2 (I-Bl lines 636-645):

> the graded completion of $M$ is defined to be $\widehat M=\bigoplus_n\widehat
> M_n$ with $\widehat M_n=\varprojlim_k M_n/N_{k,n}$,

a **direct sum** over degrees, with $N_k$ the $Q$-adic (resp. $(Q,\tilde\tau)$-adic)
chain. Iritani-Koto say the same explicitly (IK Remark 5.3, lines 2398-2401):
$\mathbf{C}[z]((q^{-1/r'}))_{\hom}$ "consists of finite sums of homogeneous elements".

Consequently $q^{\pm1/s}$ is a **unit**, not a topological nilpotent: the series
$\sum_{n\ge0}c_nq^{n/s}$ has terms in infinitely many distinct degrees and is not
an element of the ring. The same holds for $q^{-1/s}$ and for a degree-zero
scalar. So:

- the $H^0$ part $r\lambda_j\propto q^{1/r}$ is not topologically nilpotent;
- the $H^2$ part $h_{Z,j}$ is a *constant* (degree $0$) class, not nilpotent;
- the $H^{\ge4}$ tail consists of negative powers of $q$, again units.

The memo's claim of topological nilpotence is therefore false for all three
pieces, and the formal inverse function theorem (which is all that Iritani's
Lemma 5.15 provides, see F2) cannot be evaluated at the displaced target.

### F2. The sources say invertibility is of the *displaced* map, and that the pullback of functions is ill-defined

Iritani's Lemma 5.15 is followed by (I-Bl lines 5286-5292):

> Lemma 5.15 implies that the change of variables $H\to H^*(\widetilde X)$,
> $\vartheta\mapsto\tilde\tau(\vartheta)$ is (formally) invertible over
> $\mathbf{C}((q^{-1}))[[Q]]$. We can also see that the map $H\to H^*(X)\oplus
> H^*(Z)^{\oplus(r-1)}$ ... is invertible over $\mathbf{C}((q^{-\frac1{r-1}}))[[Q]]$ as
> its Jacobian matrix at $Q=\vartheta=0$ is invertible.

"(Formally) invertible ... as its Jacobian at $Q=\vartheta=0$ is invertible" is the
formal inverse function theorem: an isomorphism of the germ at $\vartheta=0$ onto
the germ at the *image* point $(\tau^\circ,\varsigma^\circ)$. Nothing in it lets
one evaluate the inverse at a target that differs from $(\tau^\circ,\varsigma^\circ)$
by a non-nilpotent amount.

Iritani-Koto make the same point in coordinates that leave no room for
interpretation. Their (5.13) (IK lines 3264-3270) defines $s_j(\hat\tau) =
\varsigma_j(\hat\tau)-\varsigma_j^\circ$ and then says:

> The formal change of variables $\hat\tau\mapsto(s_0(\hat\tau),\dots,
> s_{r-1}(\hat\tau))$ between $H^*(\mathbf{P}(V))$ and $H^*(B)^{\oplus r}$ is invertible
> over $\mathbf{C}((q^{-1/r}))[[Q]]$. Thus, we may treat $s_j=s_j(\hat\tau)$ ... as
> independent variables instead of $\hat\tau$.

The invertible map is the one in the *displaced* coordinates $s_j$, which are
formal variables of a completed ring. The memo's $\widetilde\tau_0$ is the demand
$s_j(\widetilde\tau_0)=-\varsigma_j^\circ$: setting a formal variable of the
completion equal to $\mp2q^{1/2}+O(q^{-1/2})$, an element of unit order. That is
not a point of the germ, and the source's invertibility statement says nothing
about it.

Worse for the memo, Iritani states outright that the operation Section 10 needs is
**ill-defined**. I-Bl, immediately after (5.19) (lines 4335-4340):

> Due to the constant term $h_{Z,j}$ in the change of variables
> $\sigma=\sigma_j(\theta)$, the pullback of functions $\sigma_j^*:
> \mathbf{C}[z]((q^{-1/s}))[[Q,\sigma]]\to\mathbf{C}[z]((q^{-1/s}))[[Q,\theta]]$ is ill-defined.
> However, the pullback of connections is well-defined due to the Divisor
> Equation.

and again after (5.36) (I-Bl lines 5400-5406):

> These pullbacks are well-defined due to the String and Divisor equations. The
> well-definedness can also be explained by the fact that the structures of
> $QDM(X)^{La}$ and $QDM(Z)^{La}$ are reduced to $\mathbf{C}[z][[Q,\tau]]$ and the ring
> $R$ in Remark 5.6 ...

Iritani-Koto flag the same phenomenon for the $H^0$ term, footnote 10 (IK line
3025):

> Despite the fact that the pull-back $M_B(\sigma_j+r\lambda_j)$ of the
> fundamental solution is ill-defined in the $q^{-1/r'}$-adic topology.

So the string and divisor equations are not a device the memo may borrow to make
its *inverse* substitution legal. They are the device the sources need to make the
*forward* pullback of connections legal in spite of the same displacement. Nothing
analogous exists in the reverse direction, because there is no structural equation
that undoes a substitution.

### F3. The load-bearing sentence, "the identity may be read in either direction", is the false step; without it the two halves of the contradiction sit at unrelated parameters

Memo lines 1893-1901:

> Because the change of variables is invertible, this is a bijective
> correspondence of formal germs, so the identity may be read in either direction
> and composed along the factorization. Hence for every parameter
> $\widetilde\tau$ of $X\times\mathbf{P}^1$ there is a parameter $\rho$ of $\mathbf{P}^4$ with
> $\nu_6(X\times\mathbf{P}^1,\widetilde\tau)=\nu_6(\mathbf{P}^4,\rho)$.

A weak factorization $X\times\mathbf{P}^1=V_0\dashrightarrow\cdots\dashrightarrow V_n=\mathbf{P}^4$
has steps of both orientations. At a step where the *next* variety is the blowup,
the ledger is handed a parameter of the base and must produce one of the blowup:
that is exactly the inversion refuted in F1/F2, and there it is the ambient
displacement $\tau^\circ=q^{-1}[Z]+O(q^{-2})$ (I-Bl Theorem 5.18(6), line 5661)
that must be undone --- an element of the coefficient ring, not of the maximal
ideal, since $q^{-1}$ is a unit by Remark 1.3.

The forward-only ledger does survive, and it is worth stating what it gives,
because it shows precisely how much the section loses. Weak factorization can be
arranged so that the chain first goes up and then comes down (a single "roof"
$V_{i_0}$ dominating both ends). Choosing any parameter at the roof and pushing
*down* both ways uses only forward substitutions and yields
\[
  \nu_6(X\times\mathbf{P}^1,\widetilde\tau_\star)=\nu_6(\mathbf{P}^4,\rho_\star)=0
\]
for the particular $\widetilde\tau_\star$ that the descent produces. But the other
half of the memo's contradiction is a statement at $\widetilde\tau_0$, the
parameter at which both summand parameters vanish. Matching
$\widetilde\tau_\star$ with $\widetilde\tau_0$ is exactly the base-point
independence that Section~9 (`sec:endpoint-gap`) identifies as the open problem
and that Section~10 claims to have made unnecessary. It has not been made
unnecessary; it has been relabelled as invertibility.

### F4. The same defect, in one line

The memo could equally have set $\widetilde\tau_0=0$ and obtained
$\nu_6(X\times\mathbf{P}^1,0)=\nu_6(X,\varsigma_0^\circ)+\nu_6(X,\varsigma_1^\circ)$.
That is a true statement, and it needs $\nu_6$ of the cubic **at the displaced
parameter** $\varsigma_j^\circ=\pm2q^{1/2}+O(q^{-1/2})$ --- which is exactly
Hypothesis 4.7H, exactly the residual gap of Section~\ref{sec:hyzz} (memo lines
861-868), and exactly what Section~10 claims to have made unnecessary. Choosing
the parameter instead of transporting the invariant only moves the demand from
"evaluate $\nu_6$ at a displaced parameter" to "invert a formal map at a
displaced target". The second demand is not weaker than the first; by F1-F2 it is
strictly outside what the sources establish.

---

## REPAIRABLE findings

### R1. Lemma `lem:low-dim-pointwise` overstates its own scope ("every even bulk parameter")

The KKPY input is genuinely pointwise, and I could not break its degree argument;
but its hypotheses are narrower than the memo's statement. KKPY Claim 6.15 (KKPY
lines 6317-6322) reads

> Claim 6.15. Suppose $K_X$ is nef. Then the connection $\nabla_{\partial_u} =
> \partial_u-u^{-2}Eu\star(-)+u^{-1}\mathrm{Gr}$ ... has a regular singularity at
> $u=0$. More precisely, the gauge transformed connection $(u^g\circ(\nabla+\frac12
> u^{-1}Tdu)\circ u^{-g})$ has a first order pole and a nilpotent residue at $u=0$.

and its proof (KKPY lines 6337-6344) uses three hypotheses, all of which the memo
must carry:

> Since $K_X\ge0$, and $b\in B_X^{ev}$ has a vanishing $H^0(X)$-coordinate, the
> operator $Eu\star(-)$ will move the eigenspace of $\mathrm{Gr}$ corresponding to
> an eigenvalue $m\in\frac12\Z$ to the sum of eigenspaces for eigenvalues $\ge
> m+1$. Thus ... $\kappa_{ij}=0$ for $j\le0$.

(i) $K_X$ nef; (ii) vanishing $H^0$ coordinate; (iii) $b$ a **rigid point of
$B_X^{ev}$**, whose coordinates $t_i$ for $\deg T_i\in\{4,6,\dots\}$ (and the
transcendental degree-2 ones) lie in an **open unit polydisk** --- KKPY's
construction of the base, lines 2182-2192 and (3.28) at line 2206. So Claim 6.15
does not hold "at every even bulk parameter"; it holds at even parameters whose
$H^{\ge4}$ coordinates are topologically nilpotent and whose $H^0$ coordinate
vanishes. The memo's Lemma as stated (memo lines 1852-1856) is false as literally
written and should carry those restrictions.

Three sub-checks, all of which the memo passes:

- **The $H^0$ normalization is legitimate.** Shifting the bulk by $c\cdot1$
  replaces $E\star$ by $E\star+c\,\mathrm{id}$ and leaves $\star$, $\mu$ and hence
  every residue untouched; all exponential factors move by the same $c/z$, so the
  Levelt-Turrittin residues, and therefore $\nu_6$, are unchanged. The memo
  asserts this in one sentence (memo lines 1859-1861); it is correct but deserves
  a displayed lemma, since it is what lets Claim 6.15's hypothesis (ii) be met at
  a parameter whose $H^0$ part is $r\lambda_j\propto q^{1/r}$.
- **The degree argument survives an arbitrary even $H^{\ge4}$ bulk parameter.** By
  the genus-zero dimension axiom, a bulk-insertion term of $\phi\star_\tau$ shifts
  cohomological degree by $\sum_k(\deg\phi_{i_k}-2)-2c_1\cdot d$; with $K$ nef the
  second term is $\ge0$, even insertions of degree $\ge4$ contribute $\ge0$,
  degree-2 insertions contribute $0$ (and are absorbed by the divisor equation),
  and the only negative contribution is from identity insertions, killed by (ii).
  So $\kappa_{ij}=0$ for $j\le0$ at any such parameter. This is my own
  verification, not a source claim.
- **The surface/curve induction is sound and, unlike Section 10's main ledger,
  needs only the forward direction.** $\mathbf{P}^1=\mathbf{P}(\mathcal O^{\oplus2})$ and
  $\mathbf{P}^2=\mathbf{P}(\mathcal O^{\oplus3})$ over a point; a geometrically ruled surface is
  $\mathbf{P}(V)$ over a curve; a non-minimal surface blows down; a minimal surface with
  $\kappa\ge0$ has $K$ nef. Note also that for a *curve* base $H^{\ge4}=0$, so
  Iritani-Koto's displacement $\varsigma_j^\circ$ is exactly $H^0\oplus H^2$ there
  and is disposed of by string plus divisor with nothing left over --- the one
  place in the memo where the "string and divisor dispose of it" slogan is
  actually exact.

### R2. Section 10's "what to check" item 1 is answered, but not in the memo's favour

Memo lines 1946-1949 ask whether the operation identity may be applied at an
arbitrary parameter of the formal germ. Iritani's Remark 1.4 (I-Bl lines 116-119)
says:

> The pullbacks $\tau^*QDM(X)^{la}$, $\varsigma_j^*QDM(Z)^{la}$ are defined to be
> the modules $H^*(X)\otimes\mathbf{C}[z]((q^{-1/s}))[[Q,\tilde\tau]]$, ... equipped with
> the pulled-back quantum connections.

so $\Psi$ is an isomorphism over the whole formal base, with $\tilde\tau$ a
formal *variable*. That is stronger than "at the canonical parameter" and weaker
than what Section 10 needs: it is an identity of $D$-modules over the germ at
$\tilde\tau=0$, and it says nothing about evaluating at a $\tilde\tau$ outside
that germ. The superscript "la" is the base change to
$\mathbf{C}[z]((q^{-1/s}))[[Q]]$ along (1.1), i.e. $q$ is inverted (footnote at I-Bl line
130: "The superscript 'la' means formal Laurent forms"); that localization is
harmless for $\nu_6$, since multiplicities of a root of unity in a characteristic
polynomial are stable under extension of the constant field.

### R3. Additivity of $\nu_6$ under the decomposition: fine, but for a reason the memo does not give

Memo item 3 (lines 1955-1959) invokes "the framed monodromy of a direct sum is the
union of the summands' spectra". The non-obvious point is that the summands are
indexed by $j$ through $\lambda_j=e^{2\pi ij/r}q^{1/r}$ (IK Theorem 5.1, line
2354), and the deck transformation $q^{1/r}\mapsto e^{2\pi i/r}q^{1/r}$ permutes
them cyclically. If the "turn" of Definition/Lemma `lem:turn` acted on the
ramified *coefficient* $q^{1/r}$ as well as on $z$, the framed operator would be
block-cyclic across summands and $\nu_6$ would not be additive. It is additive
only because the memo's $\sigma$ fixes $\mathcal H=\Omega_V((z))$ pointwise (memo
lines 240-241), i.e. the turn is in $z$ alone. That should be said, since the
$\mathbf{P}^4$ step (memo lines 1898-1900, "five times that of a point") is exactly where
a reader will suspect a cyclic framing.

### R4. Section 8 (`sec:rigid`): the algebra checks out, but the corollary overreaches

I recomputed every step of Section 8 and found no error.

- Lemma `lem:commutant`: $[U,C_a]=0$ forces $C_{a,0}$ into the commutant of a
  regular $2\times2$ matrix, $=B\cdot I\oplus B\cdot N$; the trace of
  $\partial_aU=C_a+[C_a,\mu]$ gives $p_a=\partial_au_0$. Correct.
- Theorem `thm:no-splitting`: $\mathrm{adj}(N)=-N$ and $N^2=-dI$ for traceless
  $2\times2$; $\mathrm{tr}(N[N,\mu_0])=0$ by cyclicity; so $\partial_ad=2q_ad$
  with $d(0)=0$, and the lowest-order argument gives $d\equiv0$. Correct.
- Step 4 shear: I re-derived $[R,E_{21}]=\begin{pmatrix}\nu&0\\
  \delta-\alpha&-\nu\end{pmatrix}$ and the $z^{-1}$ flatness coefficient
  $\partial_af\,E_{21}=k_aE_{21}+f[E_{21},G_a]+k_a[R,E_{21}]$; the diagonal
  comparison gives $k_a\nu=-f([E_{21},G_a])_{11}$ and the $(2,1)$ comparison gives
  $\partial_af=fw_a$. Correct, and the $(2,2)$ comparison is consistent because a
  commutator is traceless.
- Step 6: $\partial_aR=[R,G_a]$ and $\mathrm{adj}(XI-R)$ is a polynomial in $R$,
  so $\partial_a\det(XI-R)=0$. Correct.
- The cubic numbers: $\mathrm{tr}\,R=-19/18+1/18=-1$ and $\det R=-19/18\cdot1/18
  +2\cdot8/81=-19/324+16/81=45/324=5/36$. So $\rho^2+\rho+5/36$, roots $-1/6$,
  $-5/6$, monodromy eigenvalues $e^{-\pi i/3}$ and $e^{-5\pi i/3}=e^{\pi i/3}$,
  both primitive sixth roots. Arithmetic verified.

What does not follow is Corollary `cor:cubic-closed`'s reach, and with it the
abstract's sentence (memo lines 81-83) "so the primitive-sixth multiplicity is 2
at every bulk parameter, including a specialized one ... because specialization is
substitution into constants." Steps 1-6 construct a gauge $g$, a frame
$(e_1,e_2)$ and a shear over $B=\Lambda[[\tau]]$; the conclusion "the block at
$\tau^\bullet$ has residue conjugate to $R$" is a statement about points of that
formal germ. That the characteristic polynomial is $\tau$-constant removes the
need to *transport* it, but it does not put $\tau^\bullet$ inside the germ. So
Section 8 proves constancy on the formal even bulk germ --- which is what Cai's
gauge argument already gives (the memo concedes this at lines 93-95 and 1407-1421)
--- with the genuine gain that no pro-Laurent gauge is used, and with no gain at
all in the domain of validity. Section 8 is therefore not a route around F1.

### R5. Cai Proposition 6 supports the input value, at the right parameter

Cai's Proposition 6 (Cai3 lines 494-503) states:

> Let $\nabla$ be the big quantum connection of the cubic threefold. Then the
> operator $\nabla_z$ has solutions $S$ which contain a factor $z^\rho$ with
> $\rho\equiv\pm\frac16\bmod\Z$. Moreover, if $A^{-1}\nabla_zA$ is in Jordan
> canonical form, then $A^{-1}S$ belongs to the Jordan block of rank 2.

and his proof (Cai3 lines 470-490) obtains it from the small quantum connection at
$t=0$ via $M|_{t=0}=I$. The memo's exponents $-1/6,-5/6$ are $\pm1/6\bmod\Z$, so
the two agree, the block is rank two, and the ledger's input $\nu_6(X,0)=2$ is at
the small quantum point, which is the parameter the ledger asks for. No defect
here.

---

## COSMETIC

- Memo line 832-834 says Iritani's $\Psi$ and Iritani-Koto's $\Phi$ are
  "polynomial in $z$". They are power series in $z$: Iritani's Remark 1.5 (I-Bl
  lines 116-118) writes the base ring as $\mathbf{C}[q^{\pm1/s}][[Q,\tilde\tau]][[z]]$,
  and IK Remark 5.3 (lines 2398-2401) notes $\mathbf{C}[z]((q^{-1/r'}))_{\hom}\subset
  \mathbf{C}[q^{-1/r'},q^{1/r'}][[z]]$. Harmless for the transport theorem --- a unit of
  $\Omega[[z]]$ is still fixed by the turn --- but the sentence should be
  corrected.
- Memo line 1869 says "a nonminimal surface is a point blowup of a minimal one".
  It is a point blowup of *some* surface; the induction is on Picard rank.
- Memo line 1898-1900 says $\mathbf{P}^4$'s value is "five times that of a point"; the
  content is that each of the five summands is rank one with zero grading
  operator, hence has trivial formal monodromy. See R3.

---

## FATAL, continued

### F5. No source supplies the decomposition identity "at any parameter"; every version of it is restricted, and the restrictions exclude the parameters the ledger uses

The ledger's opening move is memo lines 1885-1886: "Each such relation, read
through the corresponding decomposition theorem **at any parameter**, gives
$\nu_6(\mathrm{Bl}_ZV,\widetilde\tau)=\dots$". There are three versions of that
theorem in the pinned sources and none of them is unrestricted.

1. **Iritani, Theorem 5.18** (I-Bl lines 5622-5641): an isomorphism of
   $\mathbf{C}[z]((q^{-1/s}))[[Q,\tilde\tau]]$-modules, i.e. over the formal germ at
   $\tilde\tau=0$ of the localized base. Not a family of pointwise statements.
2. **Iritani-Koto, Theorem 5.1** (IK lines 2338-2390): the same shape, over
   $\mathbf{C}[z]((q^{-1/r'}))[[Q,\hat\tau]]$.
3. **KKPY, Theorem 4.5** (KKPY lines 3554-3557):

   > There is a canonical isomorphism of maximal $F$-bundles between
   > $(\widehat H,\widehat\nabla)$ and $(H',\nabla')$, over an analytic domain
   > $\widehat U$ in $B_{\widehat X}$ and an analytic domain $U'$ in $B_{X'}$. The
   > union of different choices of $\widehat U$ is connected and nonempty, same
   > for $U'$.

   and the domains come from their Lemma 4.6 (KKPY lines 3574-3590), whose
   convergence hypothesis is a two-sided bound $\alpha d+\gamma<\lambda<\beta
   d+\delta$ tying the exponent $\lambda$ of $p=q$ to the total degree $d$ in the
   bulk variables, with the conclusion holding only for $|y_i|\in[0,\epsilon)$ and
   $|p|$ in a narrow annulus.

That last item is the decisive one for anyone who hopes to rescue Section 10 by
moving to the non-archimedean analytic category: the *only* place in the pinned
sources where Iritani's formal change of variables is upgraded to something one
may evaluate, KKPY have to bound the bulk coordinates by $\epsilon<1$. Section
10's $\widetilde\tau_0$ is the parameter at which the bulk coordinates are large
enough to cancel $\varsigma_j^\circ$; it is outside that domain by construction.

---

## What I verified, and how

- **Iritani's grading convention and what it does to $q$.** Read §2.2 (I-Bl lines
  636-670) in full: graded completion is $\bigoplus_n\varprojlim_kM_n/N_{k,n}$;
  $K((x))$ is the graded completion of $K[x,x^{-1}]$ along $x^nK[x]$, whose
  homogeneous elements are $\sum_{n\ge m}a_nx^n$ with $\deg a_n+n\deg x$ constant.
  With $K=\C$ and $\deg q>0$ that forces one monomial per degree, which is Remark
  1.3's identity $\mathbf{C}((q^{-1/(r-1)}))[[Q]]=\mathbf{C}[q^{\pm1/(r-1)}][[Q]]$. Cross-checked
  against IK Remark 5.3.
- **The shape of the displacement**, in both the blowup case (I-Bl Theorem
  5.18(6), $\lambda_j$ at line 5688, $h_{Z,j}$ in (5.19) at line 4300) and the
  projective-bundle case actually used at the end of the memo's proof (IK Theorem
  5.1(4), $\lambda_j=e^{2\pi ij/r}q^{1/r}$ at line 2354, and $\varsigma_j^\circ$
  in closed form at IK (5.11), line 3251).
- **What "invertible" means in the sources**: I-Bl lines 5286-5292 and IK (5.13)
  at lines 3264-3270. Both are germ-to-germ statements in displaced coordinates.
- **The sources' own warnings**: I-Bl after (5.19) (lines 4335-4340) and after
  (5.36) (lines 5400-5406); IK footnote 10 (line 3025).
- **KKPY Claim 6.15 and its hypotheses**, including the construction of
  $B_X^{ev}$ (KKPY lines 2182-2206) which puts the $H^{\ge4}$ coordinates in an
  open unit polydisk, and the degree argument in the proof (lines 6337-6344). I
  re-derived the degree shift $\sum_k(\deg\phi_{i_k}-2)-2c_1\cdot d$ from the
  genus-zero dimension axiom independently and it supports the claim at an
  arbitrary even parameter with vanishing $H^0$ coordinate.
- **KKPY's own use of the same ledger** (proof at lines 6270-6285), which runs it
  in the atoms formalism precisely so that no parameter has to be tracked.
- **All of Section 8's algebra**, recomputed by hand: the commutant lemma, the
  $\partial_a\det N=2q_a\det N$ identity including $\mathrm{tr}(N[N,\mu_0])=0$,
  the shear bookkeeping, the $z^{-1}$ and $z^0$ flatness coefficients, and the
  cubic numerics $\mathrm{tr}\,R=-1$, $\det R=5/36$, roots $-1/6,-5/6$.
- **Cai's Proposition 6** (Cai3 lines 494-503) and the proof preceding it (lines
  470-490), against the memo's use of it.

## What I could not check

- **Whether an inverse exists after allowing the string and divisor equations to
  absorb the $H^0$ and $H^2$ parts.** This is the one line of repair I can see: do
  not ask for $\varsigma_j(\widetilde\tau_0)=0$, ask for
  $\varsigma_j(\widetilde\tau_0)\in H^0\oplus H^2$, and quote string/divisor
  invariance of $\nu_6$ to finish. The residual system then displaces only in the
  negative-degree ($H^{\ge4}$) coordinates. Whether that restricted system is
  solvable, and whether the resulting substitution converges degree by degree, is
  a real question that I could not settle: homogeneity forces every order of the
  inverse series into the same $(Q^d,q^k)$ slot, so convergence needs the Taylor
  coefficients of the inverse to vanish beyond some order, and I found no
  mechanism in the sources that forces this. My tentative reading is that it
  does *not* converge, but I would not stake the refutation on it --- F1, F2, F3
  and F5 do not depend on it. If someone wants to rescue Section 10, this is the
  statement to attack, and it must be proved, not asserted.
- **The projectivity clause of weak factorization.** The memo needs the
  intermediate varieties to be smooth projective (so that both Iritani's and
  KKPY's theorems apply). Abramovich-Karu-Matsuki-Wlodarczyk do assert this when
  the two ends are projective, but that paper is not in the pinned set and I did
  not verify it against a source.
- **Whether the composite coefficient fields along a factorization chain behave.**
  Each blowup step localizes at its own exceptional variable $q_i$ ("la" = formal
  Laurent forms, I-Bl line 130) and each projective-bundle step introduces its own
  root $q^{1/r}$. The memo never names the field $\Lambda$ at each step. I believe
  this is harmless for $\nu_6$ (multiplicity of a root of unity is stable under
  field extension) but I did not check that the successive localizations are
  simultaneously realizable.
- **KKPY Lemma 5.24, Theorems 4.11, Propositions 5.17/5.22/5.23/5.30, Examples
  6.17/6.21, Remark 3.14, and the Cai quartic paper.** I read only what Section 10
  depends on; the secondary targets were examined only as far as Sections 8 and 9
  above. Section 9 is self-declared conditional and I found nothing in it that is
  wrong as stated --- its `sec:endpoint-gap` (memo lines 1561-1594) is an accurate
  description of its own gap, and its Theorem `thm:bulk-constancy` is Cai's
  formal-germ argument correctly generalized.

## What a repair would have to establish

Not a rewrite request --- just the shape of the missing statement, so that the
next version does not repeat the move:

1. A lemma saying exactly which elements may be substituted for $\widetilde\tau$
   in Iritani's and Iritani-Koto's change of variables, proved from the graded
   completion of §2.2 rather than from the word "invertible".
2. A separate lemma that $\nu_6$ is invariant under $H^0$ and $H^2$ shifts of the
   bulk parameter (string and divisor), stated as an invariance of the framed
   monodromy, not as a normalization.
3. Solvability of the resulting reduced system in the negative-degree coordinates
   only, with the convergence of the inverse substitution proved degree by degree.

Absent all three, Section 10 proves nothing that Section 9 did not already
concede was open, and the accurate statement of the current position is the one in
F4: the theorem holds if $\nu_6$ of the cubic threefold is $2$ at the displaced
parameter $\varsigma_j^\circ$, which is Hypothesis 4.7H.

---

# Second pass: the two replacement claims

Verdicts up front. **Claim A SURVIVES** --- and survives a stronger attack than the
one it defends against, because there is a second, independent proof of it that
does not go through the $z$-power count at all. **Claim B is FATAL as stated**, and
REPAIRABLE only by discarding its own engine: Cai's gauge cannot be made
admissible by per-slot polynomiality, but Section 8's $z$-regular rigidity can be
run along the same pencil and does what Claim B wants. **Claim B is the weaker of
the two, by a wide margin.**

## CLAIM A: SURVIVES

### The prior assertion in the memo is the wrong one

The memo's earlier sentence (lines 771-774) --- "for a trivial rank-two bundle all
$c_i(V)$ vanish and their $\Delta(a)$ is purely $H^0\oplus H^2$, yet
Iritani-Koto's $\varsigma_j^\circ$ still carries its $O(q^{-1/r})$ tail" --- is an
inference from the $O(\cdot)$ symbol in IK's displayed asymptotics, and the
coordinator is right to distrust it. $(1+O(q^{-1/r}))$ is a bound on which powers
of $q$ may occur, not an assertion that any of them do. It carries no information
either way about $[z^{-1}]\log$. So the memo's earlier claim was never supported;
it should be struck.

But the offered replacement reasoning ("for $c_1(V)=0$ the exponential is absent,
so the claim is that the $z^{-1}$-coefficient vanishes") is equally unsupported by
that sentence alone. What decides the question is the construction of $F_j$, and
it decides it in Claim A's favour, twice over.

### Proof 1: for a trivial bundle $F_j(1)$ is a scalar, and the $z$-power count is complete

IK build $F_j$ by stationary phase (IK §5.3, lines 2451-2540). The integrand is

> $\int e^{-\phi(\lambda)/z}\lambda^{-c_1(V)/z}\lambda^{-r/2}K(\lambda)d\lambda$
> where $\phi(\lambda)=r(\lambda\log\lambda-\lambda)-\lambda\log q$ and
> $K(\lambda)=(\widetilde\Delta^\lambda_V)^{-1}J(\lambda)$ (IK lines 2457-2460),

and $\widetilde\Delta^\lambda_V$ is the modified QRR operator, whose defining
asymptotic (IK lines 1285-1290) is

> $\Delta^\lambda_W\sim\prod_\delta\sqrt{\frac z{2\pi}}z^{\frac{\lambda+\delta}
> z}\Gamma\bigl(1+\frac{\lambda+\delta}z\bigr)$, $\delta$ ranging over the Chern
> roots of $W$.

For $V=\mathcal O_B^{\oplus r}$ every Chern root is $0$, so
$\widetilde\Delta^\lambda_V$ is a **scalar** function of $(\lambda,z)$ --- it
contains no class of $B$ at all --- and Stirling's expansion gives it as an
exponential of $\sum_{n\ge1}\frac{B_{2n}}{2n(2n-1)}\lambda^{1-2n}z^{2n-1}$, i.e.
strictly **non-negative** powers of $z$. Hence for $J=1$:

- $K(\lambda)$ is a scalar with only non-negative powers of $z$. This closes the
  coordinator's question "whether the K-tail can contribute negative $z$-powers for
  a trivial bundle": it cannot, and the reason is that the QRR operator is an
  exponential of a series in $z^{+1},z^{+3},\dots$
- $L(s,\lambda_0)=e^{-(\frac r2-1)u}e^{-uc_1(V)/z}e^{-\phi_{\ge3}(s,\lambda_0)/z}
  K(\lambda_0e^{s/\sqrt{\lambda_0}})$ (IK lines 2470-2474) is likewise a scalar,
  since $c_1(V)=0$ kills the middle factor and $u=s/\sqrt{\lambda_0}$,
  $\phi_{\ge3}$ are scalars. So $F_j(1)$ is a **scalar**, with no
  $H^{\ge2}(B)$-component whatsoever. That alone already forbids an $H^{\ge4}$
  tail in $\varsigma_j^\circ$, independently of any $z$-count.
- $\lambda_j^{-(r-1)/2}$ carries no $z$: it is a pure power of $q^{1/r}$, since IK
  define $\lambda_j=e^{2\pi\sqrt{-1}j/r}q^{1/r}$ (IK line 2354). The coordinator's
  worry that $\lambda_j$ might carry higher-degree components is a real one in the
  Hinault-Yu-Zhang-Zhang / KKPY convention, where the eigenvalue is
  cohomology-valued --- the memo itself flags this at lines 758-763 --- but **not**
  in Iritani-Koto's convention, which is the one in play. In IK's coordinates
  $\lambda_j$ is a scalar and there is nothing for the divisor equation to do.
- The factor $e^{-c_1(V)\log\lambda_0/z}$ in $F_0$ (IK line 2534) is $1$, and
  $\log\lambda_0$ therefore never enters, so the $[\log\lambda_0]$-part of IK's
  target ring is unoccupied.
- The $z$-count as offered is then complete and correct: $\phi_{\ge3}=r\sum_{k\ge3}
  \frac{s^k}{k!\lambda_0^{(k-2)/2}}$ (IK lines 2464-2467) gives $s$-degree $\ge3$
  per $z^{-1}$; the Gaussian operator $e^{z\partial_s^2/(2r)}$ evaluated at $s=0$
  converts $s^m$ into $z^{m/2}$; $K$ gives $z^{\ge0}$; the prefactor
  $e^{-(\frac r2-1)u}$ has $s$-degree $\ge1$ and no $z$ at all. Net exponent
  $\ge m/2-a\ge a/2\ge0$. So $q^{c_1(V)/(rz)}F_j(1)$ has only non-negative powers
  of $z$, its logarithm does too, and $[z^{-1}]\log(\cdot)=0$.

Two loose ends I checked rather than assumed. The logarithm is taken "with respect
to the cup product structure on $H^*(B)$" (IK line 3243); for a trivial bundle the
argument is a scalar, so the cup-product logarithm is the ordinary one and
introduces nothing. And convergence of that logarithm is IK's own assertion
("its logarithm ... is well-defined", line 3243), justified because the argument is
$\frac1{\sqrt r}\lambda_j^{-(r-1)/2}(1+O(q^{-1/r}))$ and the coefficient ring
$C[z,z^{-1}]((q^{-1/r'}))$ does admit infinite series in $q^{-1/r'}$ --- unlike
$\C((q^{-1/s}))$ with scalar coefficients --- because $K=\C[z,z^{-1}]$ has
unbounded degree in Iritani's $K((x))$ convention (I-Bl lines 671-674).

So $\varsigma_j^\circ=r\lambda_j$ exactly, by IK (5.11) (line 3251).

### Proof 2: the Kunneth/spectral argument, which needs none of the above

$\PP(\mathcal O_X^{\oplus2})=X\times\PP^1$, and the small quantum cohomology of a
product is the tensor product of the factors'. The operator $E\star$ on the product
is $E_X\star\otimes1+1\otimes E_{\PP^1}\star$, so its generalized eigenspace for the
cluster around $r\lambda_j$ is $H^*(X)\otimes v_j$, where $v_j$ is the
$j$-th eigenline of $E_{\PP^1}\star$ with eigenvalue $r\lambda_j$. The grading
operator is $\mu_X\otimes1+1\otimes\mu_{\PP^1}$, and its compression to that line
is $\mu_X+\mathrm{tr}(P_j\mu_{\PP^1})$. For $\PP^{r-1}$ the numbers
$\mathrm{tr}(P_j\mu)$ are degree-zero, permuted by the deck action
$q^{1/r}\mapsto e^{2\pi i/r}q^{1/r}$, hence all equal, and they sum to
$\mathrm{tr}\,\mu=0$; so each is $0$ (I verified this by hand for $r=2$, where
$P_\pm=\frac12(I\pm H\star/q^{1/2})$ and $\mathrm{tr}(P_\pm\mu)=0$). The $j$-th
summand is therefore $z^2\partial_z=(U_X+r\lambda_j)-z\mu_X$, which is exactly
$QDM(X)$ at bulk parameter $r\lambda_j\cdot1\in H^0$. Since the spectral summands
are canonical (they are generalized eigenspaces, not a choice), this pins
$\varsigma_j^\circ=r\lambda_j$ with no appeal to $F_j$ at all.

Two independent routes agreeing is as much as I can ask of a claim I was trying to
break.

### The string equation is exact here, and needs no smallness

This is the one place where "exact and needs no smallness" is literally true, and
it is worth saying why, since the memo's other uses of that slogan are not.
The string equation gives $\langle1,\gamma_1,\dots,\gamma_n\rangle_{0,n+1,d}=0$
except for $(n+1,d)=(3,0)$, so the structure constants of $\star_\tau$ do not
depend on the $H^0$-coordinate at all: $\star_{\tau+c\cdot1}=\star_\tau$ as an
identity, for any $c$ in the coefficient ring, with no substitution and no
convergence. The Euler field gains exactly $c\cdot1$, so
$E\star_{\tau+c1}=E\star_\tau+c\,\mathrm{id}$. Adding a scalar to $U$ translates
every exponential factor by the same $c/z$, leaves every spectral projector,
every block, and every residue untouched, and hence leaves the framed formal
monodromy unchanged. So
$\nu_6(X,\varsigma_j^\circ)=\nu_6(X,0)=2$ by Cai's Proposition 6, and

$$\nu_6(X\times\PP^1,\hat\tau=0)=\nu_6(X,2\lambda_0)+\nu_6(X,-2\lambda_1)=4$$

at the **canonical** parameter $\hat\tau=0$, inside the germ where IK Theorem 5.1
lives. No inversion, no displaced evaluation, no Hypothesis 4.7H.

### Is F4 answered?

**At the endpoint, yes.** F4's complaint was that setting $\widetilde\tau_0=0$
leaves you needing $\nu_6$ of the cubic at a displaced parameter. Claim A shows the
displacement is a pure $H^0$ shift for the trivial bundle, and an $H^0$ shift is
not a displacement the invariant can feel. The "4" half of the contradiction is now
a computed fact at a parameter that indisputably exists. F1, F2, F3 and F5 are
untouched --- they were about the *other* half.

### What then remains open for the full theorem

Exactly the zero half, and it has moved rather than vanished. With Claim A the
architecture is:

- Weak factorization can be arranged as a roof: $X\times\PP^1\leftarrow\cdots
  \leftarrow V_{i_0}\rightarrow\cdots\rightarrow\PP^4$, with every arrow a
  blowdown. Descending from any parameter of the roof --- take $0$ --- is a
  composition of **forward** substitutions only, so no inversion is needed
  anywhere. It yields $\nu_6(X\times\PP^1,\hat\tau_L)=\nu_6(\PP^4,\rho_R)=0$ for
  the two specific parameters the two descents produce, with the centre terms
  killed by the low-dimensional lemma (subject to R1's restrictions).
- Claim A gives $\nu_6(X\times\PP^1,0)=4$.
- The gap is now precisely: $\nu_6(X\times\PP^1,\hat\tau_L)$ versus
  $\nu_6(X\times\PP^1,0)$, i.e. constancy of $\nu_6$ **for $X\times\PP^1$ itself**
  along the accumulated displacement $\hat\tau_L$.

That is a strictly smaller problem than the one Section 10 previously had, and
smaller than what Claim B sets out to solve, because it is a statement about one
variety whose $\nu_6$-carrying blocks are two copies of the cubic's rank-two
Jordan block --- Section 8's exact hypotheses --- rather than a statement about
arbitrary intermediate fourfolds. Also note that only a **lower** bound is needed:
if the two cubic-type blocks keep their exponents at $\hat\tau_L$ then
$\nu_6(X\times\PP^1,\hat\tau_L)\ge4>0$ and the contradiction closes; no control of
the other blocks is required. That asymmetry is worth exploiting and the memo does
not currently use it.

One caveat on the descent: at each step past the first, the base parameter is
$\tau_{i+1}(\cdot)$ evaluated at the accumulated parameter, not at $0$. That
substitution is legitimate for the same reason Iritani's own pullback is --- the
accumulated parameter has only $H^{\ge4}$ components, each insertion costs at
least $2$ in the dimension axiom, so only finitely many insertions survive per
Novikov degree --- but it is a lemma, and it should be stated and proved rather
than assumed.

## CLAIM B: FATAL as stated; REPAIRABLE by replacing its engine

### What is right in it

Two of the three ingredients are real.

- **The three shapes are supported by the sources, for the ambient displacement.**
  I-Bl Theorem 5.18(6) (line 5661) gives $\tau^\circ=q^{-1}[Z]+O(q^{-2})$, which is
  *purely* the third shape: $[Z]\in H^{2r}$ with $r\ge2$, so there is no $H^0$ and
  no $H^2$ part at all in the ambient displacement, and every term is a negative
  power of $q$. The first two shapes occur only in the centre displacement
  $\varsigma_j^\circ=-(r-1)\lambda_j+h_{Z,j}+O(q^{-1/(r-1)})$, with
  $h_{Z,j}=\frac{2\pi i}{r-1}(j+\tfrac12)\rho_Z$ a $q$-free divisor class (I-Bl
  (5.19), line 4300) --- and the centre terms are the ones the ledger discards
  anyway. So for the chain the claim is not merely supported, it is stronger than
  stated. Whether the *accumulated* displacement keeps the three shapes is not in
  any source and does need the lemma noted above.
- **Per-slot polynomiality in $t$ is real, not a truncation artifact --- but the
  reason given is not the reason.** The offered justification ("at $Q^0$ the
  monomial order is bounded by $\dim V-1$") covers only the classical slot, and
  even there it is off: at $Q^0$ the structure constants have *no* $t$-dependence
  at all, since $\langle\phi_a,\phi_b,\phi^c,\delta,\dots,\delta\rangle_{0,n+3,0}=0$
  for $n\ge1$. The real mechanism is the dimension axiom: a term with $n$ bulk
  insertions of $\delta$ shifts cohomological degree by
  $\sum_k(\deg\delta_k-2)-2c_1\cdot d$, so with $\delta\in H^{\ge4}$ each insertion
  costs at least $2$ and $n\le(2\dim+2c_1\cdot d)/2$ is bounded **for each fixed
  Novikov degree $d$**. That gives polynomiality in $t$ per $Q^d$ slot for the
  connection matrix, and it is exactly why the $H^2$ part must be removed by the
  divisor equation first: a degree-2 insertion costs $0$, permits unboundedly many
  insertions, and resums to $e^{\delta_2\cdot d}Q^d$, which is not polynomial in
  $t$. The claim is right to dispose of the first two shapes before starting, but
  it should say that this is a precondition of the pencil argument rather than a
  convenience.
- **Flatness in the $t$-direction is not an issue.** The quantum connection is flat
  over the whole bulk space; its pullback along any map, in particular along the
  affine line $t\mapsto t\delta$, is flat, with $\nabla_t=\partial_t+z^{-1}
  (\delta\star_{t\delta})$ by the chain rule. The coordinator's third attack point
  fails: there is nothing non-integrable about a pencil.

### Where it dies

Cai's gauge does not become admissible. Solve $\partial_tM=-z^{-1}C_tM$,
$M|_{t=0}=I$. Track it per Novikov slot:

- at $Q^0$, $C_t$ is the constant $\delta\cup$, so $M^{(0)}=\exp(-tz^{-1}\delta\cup)$,
  which terminates by nilpotency of $\delta\in H^{\ge4}$ and has $z$-order $\ge-\dim$;
- at $Q^d$, a term is a product of at most $N(d)\le\omega\cdot d/\omega_{\min}$
  quantum factors interleaved with those terminating exponentials, so it is
  polynomial in $t$ **and** has $z$-order bounded below --- by roughly
  $-(1+\dim)N(d)$.

So the per-slot picture is exactly as Claim B says, and $M|_{t=1}$ makes sense slot
by slot. And that is the problem: the bound degrades **linearly in $\omega\cdot d$**,
so summed over Novikov degrees the $z$-order of $M|_{t=1}$ is unbounded below.
$M|_{t=1}$ lies in $\mathrm{End}(H)\otimes\Lambda_{\mathrm{Nov}}[[z^{-1}]]$ and not
in $\mathrm{End}(H)\otimes\Lambda_{\mathrm{Nov}}((z))$. Theorem `thm:transport`
requires $G\in\mathrm{GL}_n(\mathcal H)$ with $\mathcal H=\Omega_V((z))$; $M|_{t=1}$
is not in it, for precisely the reason the memo already identified for the
pro-Laurent gauge (its own lines 851-853, "per bulk degree it is a polynomial in
$z^{-1}$ ... unbounded only after summing over bulk degrees"). Claim B has changed
the index of summation from bulk degree to Novikov degree and left the divergence
where it was.

Worse, the trade it induces is the memo's own criterion in disguise. $M$ gains one
$z$-pole per Novikov unit, while the splitting gauge that produces the
Levelt-Turrittin form loses $w(\Delta\lambda)$ per unit of $z$-power (memo's
Section 3, "the two rates"). Forming the comparison at all is the product $GP$
whose convergence is exactly $e\,w(\Delta\lambda)<\varepsilon$. So Claim B's
promise --- "without any Hahn field, any receiver, or the weight criterion" --- is
the one part of it that is false. Answering the coordinator's second attack point
directly: Cai's argument uses only flatness and ring structure, as claimed; what it
smuggles in is not analyticity but a **ring** in which an $\mathrm{id}+O(z^{-1})$
series is a gauge, and no such ring is available once the bulk parameter is
specialized.

### The repair, named

Do not use Cai's gauge. Use Section 8's machine along the same pencil. Its objects
live on the right side of the loop coordinate: the block-diagonalizing gauge is
$g=I+O(z)$, a **positive** power series in $z$, and the shear is
$\mathrm{diag}(1,z)$; both are in $\mathrm{GL}(\Lambda((z)))$, and no
$\mathrm{id}+O(z^{-1})$ object appears anywhere in Steps 1-6. Then:

1. Per-slot polynomiality in $t$ propagates through Steps 1-6: the Sylvester
   recursions multiply connection coefficients and divide by eigenvalue differences,
   and the inverse of a unit $u_0(1+v)$ with $v$ in the Novikov ideal contributes at
   most $N(d)$ terms per $Q^d$ slot, each polynomial in $t$. So $g$, the frame, and
   $R$ are polynomial in $t$ per $(Q^d,z^k)$ slot. This needs writing out, but I see
   no obstruction.
2. Section 8's vanishing arguments then upgrade from formal to global on the
   pencil for free: $\det N$ and $f$ are shown to vanish as elements of
   $\Lambda[[t]]$, and a power series that vanishes and is *also* a polynomial per
   slot vanishes identically, hence at $t=1$. Likewise $\partial_tR=[R,G_t]$ makes
   $\det(XI-R)$ a $t$-constant polynomial, so its value at $t=1$ is its value at
   $t=0$. This is the "domain rather than validity" upgrade Claim B was reaching
   for, and the pencil is what supplies it --- but it works only for the
   $z$-regular argument, not for Cai's.
3. What it costs: Section 8's (H1) and (H2) must hold along the whole pencil. Its
   own Theorems `thm:no-splitting` and `thm:no-irregularity` propagate them, so the
   requirement is really at $t=0$ only, plus the exclusion of the degeneration
   locus where the nilpotent part vanishes --- which is the caveat the memo's own
   Section 9 already records at lines 1591-1594.

Combined with the observation at the end of the Claim A discussion --- that after
Claim A the only constancy still needed is for $X\times\PP^1$, whose
$\nu_6$-carrying blocks are two copies of the cubic's rank-two Jordan block, and
that only a lower bound is needed --- this repair is within reach in a way that
Claim B's own version is not. But as written, Claim B asserts the thing that fails
and justifies the things that do not need justifying.

## Which is weaker

Claim B, decisively. Claim A is a computation with two independent proofs and an
exact invariance principle behind it. Claim B is a correct observation about
polynomiality attached to an engine that the observation does not fix; its
substance survives only if it is rebuilt around Section 8.
