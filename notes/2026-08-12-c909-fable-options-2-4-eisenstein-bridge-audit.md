# C909 audit: Fable Options 2/4 and the quantum--cycle quadratic packet

**Date:** 2026-08-12  
**Scope:** bounded unification audit against the C909 cycle/quantum notes and
the Fable Option 2 (exceptional closure) / Option 4 (self-reconstructing
cubic) proposals. No manuscript, PDF, mirror, or Lean edits.

## Verdict

The strongest positive result is a coefficient-packet theorem, not a
cycle--quantum comparison theorem:

\[
 \mathcal O_3=\mathbf Z[t]/(t^2+t+1)=\mathbf Z[\zeta_3]
\]

has the two exotic graph slopes in its fibre modulo `2`, and acts on a
specified cubic quantum rank-two formal block by (t\mapsto -M\), where (M)
has the primitive-sixth eigenvalues from Cai. Frobenius at (2) and quantum
meridian reversal both realize the nontrivial involution of (mathcal O_3).

There is no theorem-grade identification of this packet with (J(X)), no
mixed-characteristic degeneration from the (F_4) heart to the quantum
block, and no equality of the corresponding parameter-space (C_2)-torsors.
Thus the common-packet statement is **GO as an explicitly qualified
arithmetic compression**; promoting it to the unifying bridge required by
Options 2 or 4 is **NO-GO/MAJOR**.

## What is actually canonical

### Cycle side

For the six-point (A_5) heart (H),

\[
 D=\operatorname{End}_{\mathbf F_2A_5}(H)=\mathbf F_4,
 \qquad
 \mathcal K_{\rm ex}=\{\Gamma_\omega,\Gamma_{\omega^2}\}.
\]

The unordered exotic graph packet is intrinsic to the marked hyperbolic
discriminant problem. Frobenius exchanges its two members. Equivalently,
after an (\mathbf F_2)-algebra identification

\[
 \mathcal O_3/2\mathcal O_3\simeq\mathbf F_4,
\]

the packet is the geometric-point packet of the inert special fibre. The
identification, and an ordered choice of one graph, are not canonical without
the golden orientation/marking. The congruence audit gives the exact modular
cover (r^2=T); on the signed cubic coordinate (T=81t^2), (r=9t), so
the chosen signed presentation trivializes this particular graph-marking
cover.

### Quantum side

Cai’s calculation gives the rank-two **even** cubic block with residues

\[
 -\tfrac16,\ -\tfrac56,
 \qquad
 \operatorname{Spec}(M)=\{e^{-\pi i/3},e^{\pi i/3}\}.
\]

For a designated block and the positive formal meridian, (N=-M) satisfies

\[
 N^2+N+1=0,
 \qquad
 \mathbf Z[\zeta_3]\longrightarrow\operatorname{End}_{\mathbf C}(V),
 \quad \zeta_3\longmapsto N.
\]

This action is functorial relative to the specified differential module and
meridian; it does not select an eigenline. Reversing the meridian sends
(N) to (N^{-1}), which is the nontrivial automorphism of
(\mathcal O_3). This is the exact quantum-side statement.

The even block is not an action on (H^3(X)), and no cited result constructs
an integral (\mathcal O_3)-lattice, a (2)-adic quantum lattice, or an
intertwiner to the (A_5) heart. The KKPYY zero-atom comparison can place
the even block inside a designated zero atom when its formal-isomonodromy and
parity hypotheses are printed, but that atom may also contain the odd
(H^3) sector. Atom containment is not an identification with the
intermediate Jacobian.

## Is Cai’s packet canonically tied to (J(X))?

**No, on the present evidence.** The load-bearing reasons are structural:

1. Cai’s primitive-sixth roots are computed in the even small quantum
   connection. The intermediate Jacobian is built from the odd (H^3(X))
   Hodge structure; no map from the even rank-two quantum block to
   (H^3(X)), its lattice, or (J(X)) is supplied.
2. At the small point the odd (H^3) summand is quantum-trivial with
   formal monodromy (1), while the primitive-sixth pair occurs in the even
   block. This rules out reading the roots as the monodromy of the IJ
   variation itself.
3. The small even calculation is a deformation-class computation, whereas
   (J(X)) varies over the cubic period locus. Any extension to a big/atomic
   setting uses a separate formal-isomonodromy and continuation theorem; it
   does not become an IJ variation. A canonical tie would require an
   additional geometric correspondence, not just the fact that both
   constructions are attached to the same cubic.

The safe positive statement is therefore:

> At the small point, and on any connected parity-fixed spectral component
> reached by the stated formal-isomonodromy continuation, the primitive-sixth
> pair is a canonical spectral feature of the framed quantum differential
> module; under the KKPYY atom-comparison hypotheses it is a feature of the
> corresponding zero quantum atom. It is not presently a canonical invariant
> or endomorphism of (J(X)).

This distinction also protects the C909 separation theorem: the cycle
certificate belongs to the IJ and the quantum certificate belongs to the
quantum connection. Their simultaneous nonvanishing is a geometric
intersection statement, not a common detector.

## Is there a degeneration or torsor bridge?

There is an exact arithmetic diagram, but not a degeneration:

```text
cycle:   O_3/2 = F_4  ->  {Gamma_omega, Gamma_omega^2}
                         (Frobenius)

quantum: O_3 tensor C  ->  {zeta_3, zeta_3^2}
                         (meridian reversal / scalar conjugation)
```

The two rows are fibres of the abstract finite-etale coefficient order
(\operatorname{Spec}\mathcal O_3[1/3]), but they lie in different fibre
functors. No integral quantum model over (\mathcal O_3), reduction map from
the quantum block to (H), mixed-characteristic connection, or geometric
family over a common base is constructed. Calling this a degeneration would
silently add all of those missing data.

The parameter-space obstruction is equally precise. Let (K_{\rm ex}) be
the (C_2)-torsor of exotic graph markings over a common base (S). To
compare it with the quantum construction one must first construct a quantum
orientation/descent torsor (Q\to S) for the designated block and then prove

\[
 [K_{\rm ex}]=[Q]\in H^1_{\mathrm{et}}(S,C_2).
\]

The bare quantum eigenvalue pair is split after choosing the complex roots
and the formal meridian; it does not itself supply a nontrivial (Q). On the
coarse modular (T)-line, (K_{\rm ex}) is the nontrivial cover (r^2=T);
on the signed cubic coordinate (t), it is already trivialized by
(r=9t). Neither fact produces a quantum torsor or identifies its class.

Therefore there is no exact (F_4)-Frobenius/quantum-monodromy torsor bridge
in the current C909 record. The involutions are the same abstract element of
(\operatorname{Aut}(\mathcal O_3)\), not the same family monodromy.

## Option-specific ruling

### Option 2: exceptional (E_6) closure

The six-axis cycle package can support the conference/root/Cartan part of an
exceptional-closure theorem, subject to the independent exact tensor and
reverse-reconstruction gates recorded in the Fable review. The quantum
primitive-sixth packet contributes no theorem toward the (27)-dimensional
minuscule prolongation: it has no map to the Cartan cubic, no (E_6) weight
dictionary, and no IJ comparison. Option 2 is therefore **NO-GO as a unified
cycle--quantum theorem**. Its strongest surviving form is a cycle/operator
exceptional-closure conjecture with the Eisenstein packet mentioned only as
motivation.

### Option 4: self-reconstructing Clebsch cubic

Option 4 can remain a cycle-side master architecture: a self-shadowing cubic
may reconstruct the six-axis operator and its arithmetic envelope. But the
claim that the resulting cubic is thereby tied to Cai’s primitive-sixth
packet is unsupported. Adding that clause requires the same three missing
objects: a global designated quantum block, a quantum orientation torsor, and
an intertwiner or equality of (H^1(S,C_2)) classes. Option 4 is thus
**conditional GO without the quantum bridge**, and **MAJOR overclaim with
the bridge asserted**.

## Exact promotion wording

The highest safe unity sentence is:

> The exotic (A_5) graph pair and the cubic primitive-sixth quantum block
> realize two independent fibres of the same abstract Eisenstein quadratic
> order: (F_4) with Frobenius at (2), and the complex negative-monodromy
> pair with meridian reversal. We use no identification between their
> geometric lattices, period variation, or parameter-space torsors.

Keep out of theorem statements:

- “Cai’s packet is the intermediate-Jacobian packet”;
- “Frobenius equals quantum monodromy”;
- “the cubic family is a degeneration of the (F_4) heart”;
- “Options 2/4 produce a common (\mathcal O_3)-module or (E_6) quantum
  closure.”

## Audit sources/notes

- `notes/2026-08-10-c904-c907-enhanced-atom-bridge-blueprint.md` — Cai/KKPYY
  atom interface and the even-block containment gate;
- `notes/2026-08-12-c909-cubic-nu6-odd-h3-upper-bound-audit.md` — exact
  small-point odd/even separation and continuation caveat;
- `notes/2026-08-12-c909-eisenstein-operator-canonicity-audit.md` and
  `notes/2026-08-12-c909-eisenstein-two-shadow-theorem-audit.md` — exact
  (\mathcal O_3) action and its limit;
- `notes/2026-08-12-c909-exotic-cover-congruence-audit.md` and
  `notes/2026-08-12-c909-fixed-graph-modular-normalization-theorem.md` —
  (r^2=T), (T=81t^2), (r=9t), and the marking cover;
- `notes/2026-08-03-clebsch-program-unity-review.md` — Fable Options 2 and 4
  and their independent missing gates.
