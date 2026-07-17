# C250 proof-carrying remediation portfolios

**Lane:** `rp-next`
**Status:** COMPLETE — end-to-end certificate succeeds; formal-methods novelty gate fails. Typed
action lineage, a cheap disabling witness, and a portfolio lower-bound proof reduce to a small
checker, but the result is a clean composition of proof-carrying plan validation, ordinary
fault-tree cut sets, and standard SAT/PB proof logging. Retain the artifact as product engineering
and an evidence-interface specification; make no new-formal-object claim.

## Decision

Keep a proof-carrying remediation bundle with four independently checked pieces:

1. an untrusted typed plan;
2. dependencies derived from trusted action schemas and resource annotations, never accepted from
   the agent's prose;
3. a cheap portfolio-wide disabling witness when one exists; and
4. a proof log showing that no disabling set below a claimed budget exists.

Do not present the bundle, its minimum-cut optimization, or the dependency-composition theorem as a
new formal method. The useful seam is operational: it makes the trust boundary explicit and gives a
common artifact to an agent planner, an infrastructure inventory, a portfolio optimizer, and a
small checker. Its guarantee remains conditional on the completeness of the trusted resource-to-
failure-domain annotations.

## Small typed model

Let every primitive resource `r` have a type and a finite set `delta(r)` of failure domains. A
typed action consumes earlier values and produces one value. The bounded C250 semantics are:

- a primitive resource is available under failure set `F` exactly when
  `F intersect delta(r) = empty`;
- an action succeeds exactly when all its typed inputs succeed;
- plans are finite acyclic action lists, and their terminal value has type
  `remediation_success`.

Define lineage recursively by

```text
L(resource r) = delta(r)
L(action a(v_1,...,v_k)) = union_i L(v_i).
```

This model deliberately excludes disjunction inside a plan, mutable state, compensation, temporal
conditions, and hidden ambient dependencies. Those belong to later empirical or continuation
tasks; silently admitting them here would make the extraction theorem false.

> **Typed-lineage completeness theorem.** For every well-typed value `v` and failure set `F`, `v`
> succeeds exactly when `F intersect L(v)` is empty. Consequently, the extracted terminal lineage
> is exactly the set of domains whose individual failure disables the plan. A portfolio is disabled
> exactly when `F` is a transversal of its extracted terminal lineages.

**Proof.** Induct over the acyclic construction of `v`. The resource case is the primitive-resource
semantics. In the action case, the action succeeds exactly when every input succeeds; the induction
hypothesis makes this equivalent to `F` avoiding every input lineage, hence to avoiding their
union. Apply the result to each terminal value. The portfolio statement is conjunction over plan
failure. This also shows the theorem's exact boundary: an undeclared primitive dependency is
outside the semantics and cannot be certified by the plan alone.

## End-to-end fixture

The fixture has three surface-distinct remediation plans:

| Plan | Typed source | Checker-derived failure domains |
|---|---|---|
| database restore | database credential vault | `control_plane`, `trust_root` |
| control restart | orchestrator credential vault | `control_plane`, `network` |
| DNS failover | DNS credential vault | `network`, `trust_root` |

Each plan mints a credential and passes it to a different remediation action. The untrusted plan
does not state its terminal dependency set; the checker type-checks references and propagates the
trusted primitive lineage.

With unit domain costs, a disabling set of cost below two would choose at most one of three Boolean
variables. The generated DIMACS instance contains the three plan-hit clauses

```text
(control_plane or trust_root)
(control_plane or network)
(network or trust_root)
```

and the three pairwise at-most-one clauses. An untrusted exhaustive producer emits a 13-step
resolution refutation, which the checker replays from the reconstructed clauses. Independently,
`{trust_root, control_plane}` is checked as a cost-two attack hitting every plan. Thus

```text
rho_w(portfolio) >= 2     resolution certificate
rho_w(portfolio) <= 2     explicit attack witness
rho_w(portfolio)  = 2.
```

The executable artifacts are:

- [`2026-07-17-c250-proof-carrying-remediation.py`](2026-07-17-c250-proof-carrying-remediation.py),
  containing the untrusted producer and logically separate checker;
- [`2026-07-17-c250-proof-carrying-remediation-fixture.json`](2026-07-17-c250-proof-carrying-remediation-fixture.json),
  the typed schemas, primitive annotations, and agent plans;
- [`2026-07-17-c250-proof-carrying-remediation-certificate.json`](2026-07-17-c250-proof-carrying-remediation-certificate.json),
  the claimed lineage, attack, clauses, and resolution log; and
- [`2026-07-17-c250-proof-carrying-remediation-lower-bound.cnf`](2026-07-17-c250-proof-carrying-remediation-lower-bound.cnf),
  the reconstructed SAT instance.

Run the producer and checker with

```sh
python3 notes/2026-07-17-c250-proof-carrying-remediation.py --emit
python3 notes/2026-07-17-c250-proof-carrying-remediation.py
```

The checked result is three valid plans, exact resilience two, and a 13-step refutation. A mutation
of the final proof clause is rejected. The small explicit-resolution format is sufficient for this
fixture; a production implementation should emit a standard VeriPB/CakePB-supported proof rather
than grow this checker.

## Trust and evidence boundary

| Component | May be untrusted? | What the checker establishes |
|---|---:|---|
| agent plan | yes | references, types, acyclicity, terminal success type |
| claimed plan dependencies | yes | exact equality with schema-derived lineage |
| portfolio optimizer | yes | nothing is accepted from its objective value |
| attack producer | yes | budget and intersection with every derived plan lineage |
| lower-bound producer | yes | every resolution step and final contradiction |
| action schemas and resource annotations | no | semantic root of the guarantee |
| checker and instance binding | no | trusted base |

The important negative is the sixth row. The checker proves completeness *relative to* the action
model, but cannot prove that `dns_vault` really depends on the stated trust root and network, or that
no ambient IAM, human approval, vendor, or specification dependency was omitted. Observed lineage,
inventory attestation, and fault injection can supply evidence for those annotations, but then the
artifact becomes an assurance-case/LDFI integration rather than a stronger deductive theorem.

## Literature gate

All five neighboring boundaries are already occupied.

- Abdulaziz and Koller give Isabelle/HOL semantics and a formally verified temporal-plan validator
  ([AAAI 2022](https://ojs.aaai.org/index.php/AAAI/article/view/21197)). Plan validity behind a small
  checker is established territory.
- Hill, Komendantskaya, and Petrick explicitly call their object **Proof-Carrying Plans**, interpret
  plans as typed functions, and provide an Agda soundness formalization
  ([PPDP 2020](https://arxiv.org/abs/2008.04165)). Typed action composition is therefore not a new
  agent-specific certificate idea.
- Mugdan, Christen, and Eriksson give independently checkable optimality certificates for classical
  planning ([ICAPS 2023](https://ojs.aaai.org/index.php/ICAPS/article/view/27206)). Dold et al. go
  closer still: their planning lower-bound certificates use pseudo-Boolean proof logging and are
  planner-agnostic ([ICAPS 2025](https://ojs.aaai.org/index.php/ICAPS/article/view/36101)).
- VeriPB already provides a general pseudo-Boolean certificate format, and its kernel output can be
  checked by the formally verified CakePB checker ([VeriPB project](https://veripb.org/)). The C250
  resolution log is a tiny instance, not a new proof system.
- Classical fault-tree analysis already treats minimal cut sets as the failure objects, and model
  checking can generate them automatically
  ([Kromodimoeljo--Lindsay 2015](https://arxiv.org/abs/1506.03555)). The portfolio transversal is the
  cut set of an AND-over-plan-failures success structure.
- MOLLY's lineage-driven fault injection reasons backward from successful outcomes, compiles
  bounded candidate failures through SAT, and aims for sound counterexamples plus bounded
  completeness
  ([SIGMOD 2015](https://people.ucsc.edu/~palvaro/molly.pdf)). Joining declared prospective lineage
  to observed lineage is useful, but not a new cut-set or bounded-exhaustion guarantee.

The composition was not found as this exact remediation bundle, but each theorem-bearing part is
standard and composes without a new mathematical obstruction. The phrase “proof-carrying
remediation portfolio” is defensible product language only if accompanied by these boundaries.

## Kill-gate disposition

C250 satisfies the engineering success gate:

- the agent plan, portfolio solver, and proof producer are outside the trusted base;
- dependency extraction has an exact relative-completeness theorem;
- upper and lower robustness bounds are independently checked; and
- the smallest triangle fixture exposes shared dependencies hidden behind distinct actions.

It fails the research success gate. The agent-specific evidence boundary does not yield a smaller
semantic trusted base than proof-carrying plans plus a resource inventory, and it does not add a
new compositional guarantee beyond fault-tree lineage and proof-logged Boolean optimization.

Retain the schema and checker as the formal input contract for C251's blinded common-mode
benchmark. C251 must test whether trusted annotations can be made reproducible and predictive;
formal repackaging cannot answer that empirical question.
