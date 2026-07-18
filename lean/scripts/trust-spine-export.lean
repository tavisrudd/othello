/-
Lean-side fact extractor for the C326 trust spine.

This file is never imported and is not part of any lake library.  `lean-trust-extract.py` reads it,
strips its own `import` lines, prepends `import Lean` plus one `import <extraction unit>`, appends a
single `#eval`, and elaborates the result through `guarded-lean`.  Keeping the body here — tracked,
hashed, and elaborable on its own against core `Lean` alone — is what makes the `exporter_sha256`
field of a facts artifact refer to something a reader can check.

What it reports is Lean's resolved environment, not a parse of source text.  Terminal axiom sets come
from `Lean.collectAxioms`, the same routine `#print axioms` uses.

Reporting and canonicalization are deliberately split.  This file emits what the environment says, in
whatever order the constant map yields; `lean-trust-extract.py` sorts, deduplicates, validates, and
writes the tracked artifact.  Keeping ordering logic out of Lean keeps the metaprogram small enough
to audit by reading it.
-/
import Lean

namespace TrustSpine

open Lean

/-- A declaration is project-local when its defining module sits under one of the lake libraries the
portfolio registry classifies.  The root set is never inferred here; `lean-trust-extract.py` passes
it from `lean/trust/portfolio.toml`, so a library that the registry does not classify cannot quietly
become "project-local" for the purposes of an axiom check. -/
def isProjectModule (roots : Array Name) (m : Name) : Bool :=
  roots.any fun r => r == m || r.isPrefixOf m

/-- The module a declaration was compiled in.  `none` means the declaration belongs to the current
file, which for a generated wrapper means it is not an imported project fact. -/
def moduleOf? (env : Environment) (n : Name) : Option Name := do
  let idx ← env.getModuleIdxFor? n
  env.allImportedModuleNames[idx.toNat]?

/-- Constants whose body Lean genuinely does not expose, excluding axioms, which are reported
separately as declared trust assumptions.  A missing body must never be presented as a complete
dependency record, so these are named in the artifact and the graph marks them as boundaries.

Only `opaque` declarations qualify.  A theorem is *not* a boundary: `ConstantInfo.value?` hides
proof terms behind its `allowOpaque` flag by definition, not because an imported proof is
unavailable, and `usedConstants` below passes `allowOpaque := true` precisely so that proof-term
dependencies are recorded.  Treating theorems as boundaries here would have reported the trust
graph as partial when it is not. -/
def isOpaqueBoundary (info : ConstantInfo) : Bool :=
  match info with
  | .opaqueInfo _ => true
  | _ => false

/-- Constants named in a declaration's type and, when available, its value.  This is the raw `uses`
edge set; the driver filters it to project-local targets and deduplicates. -/
def usedConstants (info : ConstantInfo) : Array Name :=
  let fromType := info.type.getUsedConstants
  match info.value? (allowOpaque := true) with
  | some v => fromType ++ v.getUsedConstants
  | none => fromType

private def nameArr (ns : Array Name) : Json :=
  Json.arr (ns.map fun n => Json.str n.toString)

private def nameMap (ps : Array (Name × Array Name)) : Json :=
  Json.mkObj (ps.toList.map fun (n, vs) => (n.toString, nameArr vs))

/-- Extract one extraction unit and write its facts artifact.

`includeUses := false` drops the declaration-level dependency edges.  It exists because a proof term
in a large certificate closure can be very large, and a memory failure while gathering graph edges
should not cost the axiom facts, which are the trust-bearing part. -/
def run (unit : Name) (roots : Array Name) (terminals : Array Name)
    (leanToolchain mathlibRev exporterSha256 outPath : String)
    (includeUses : Bool := true) : MetaM Unit := do
  let env ← getEnv

  let closure := env.allImportedModuleNames.filter (isProjectModule roots)

  let declsRef ← IO.mkRef (#[] : Array Name)
  let axiomsRef ← IO.mkRef (#[] : Array Name)
  let declModRef ← IO.mkRef (#[] : Array (Name × Name))
  let usesRef ← IO.mkRef (#[] : Array (Name × Array Name))
  let opaqueRef ← IO.mkRef (#[] : Array Name)

  env.constants.forM fun name info => do
    -- Compiler-generated names are filtered from nodes and edges alike, so the graph never carries
    -- an edge to a declaration the artifact does not also list.
    if name.isInternal then
      return ()
    let some m := moduleOf? env name | return ()
    unless isProjectModule roots m do
      return ()
    declsRef.modify (·.push name)
    declModRef.modify (·.push (name, m))
    if info matches .axiomInfo _ then
      axiomsRef.modify (·.push name)
    if isOpaqueBoundary info then
      opaqueRef.modify (·.push name)
    if includeUses then
      usesRef.modify (·.push (name, usedConstants info))

  -- A terminal missing from this unit's environment is left absent rather than recorded as having
  -- an empty axiom set.  The checker reports the absence; an empty set would read as a pass.
  let terminalAxiomsRef ← IO.mkRef (#[] : Array (Name × Array Name))
  for terminal in terminals do
    if env.contains terminal then
      let used ← collectAxioms terminal
      terminalAxiomsRef.modify (·.push (terminal, used))

  let doc := Json.mkObj [
    ("schema_version", Json.num 1),
    ("unit", Json.str unit.toString),
    ("lean_version", Json.str Lean.versionString),
    ("lean_toolchain", Json.str leanToolchain),
    ("mathlib_rev", Json.str mathlibRev),
    ("exporter_sha256", Json.str exporterSha256),
    ("uses_included", Json.bool includeUses),
    ("closure", nameArr closure),
    ("project_declarations", nameArr (← declsRef.get)),
    ("project_axioms", nameArr (← axiomsRef.get)),
    ("terminal_axioms", nameMap (← terminalAxiomsRef.get)),
    ("declaration_module",
      Json.mkObj ((← declModRef.get).toList.map fun (n, m) => (n.toString, Json.str m.toString))),
    ("uses", nameMap (← usesRef.get)),
    ("opaque", nameArr (← opaqueRef.get))
  ]

  IO.FS.writeFile outPath (doc.compress ++ "\n")

end TrustSpine
