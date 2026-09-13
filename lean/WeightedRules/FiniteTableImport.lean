import Lean

/-!
# Importing finite natural-number tables as untrusted data

`nat_table_from_json` reads a JSON array at an explicit object-key path and
inserts a list of natural-number literals into the elaborated term. It accepts
at most 65,536 entries, each less than `2^32`, from a UTF-8 file of at most one
MiB. Relative paths are resolved against the containing Lean source file.
The file read itself is bounded. No imported value is parsed as Lean code,
and this operation establishes no mathematical property of the table.

Semantic coverage, entry ranges for a particular finite type and the claimed
equations must be checked by the consumer's proofs. The parser and the source
file are not mathematical authorities.
-/

namespace WeightedRules
open Lean Elab Term

private def readNaturalTable (path : System.FilePath) (keys : List String) : IO (List Nat) := do
  let bytes ← IO.FS.withFile path .read fun handle => do
    let mut bytes := ByteArray.empty
    repeat
      let chunk ← handle.read (1048577 - bytes.size).toUSize
      if chunk.isEmpty then break
      bytes := bytes ++ chunk
      if bytes.size > 1048576 then throw (IO.userError "table file exceeds byte limit")
    return bytes
  let some payload := String.fromUTF8? bytes
    | throw (IO.userError "table file is not UTF-8")
  let result : Except String (List Nat) := do
    let mut json ← Json.parse payload
    for key in keys do
      json ← json.getObjVal? key
    let values ← json.getArr? |>.mapError fun _ => "expected a table array"
    if values.size > 65536 then throw "table exceeds entry limit"
    let values ← values.toList.mapM fun value =>
      value.getNat? |>.mapError fun _ => "table entry must be a natural number"
    if values.any (· ≥ 4294967296) then throw "table entry exceeds natural-number limit"
    return values
  match result with
  | .ok values => return values
  | .error message => throw (IO.userError message)

/-- Import only natural-number literals from the named JSON object path;
the consumer separately proves all semantic properties of the resulting list. -/
syntax "nat_table_from_json " str " at " "[" str,* "]" : term

elab_rules : term
  | `(nat_table_from_json $path:str at [$keys:str,*]) => do
    let sourceDir := (System.FilePath.mk (← getFileName)).parent.getD "."
    let tablePath := System.FilePath.mk path.getString
    let tablePath := if tablePath.isAbsolute then tablePath else sourceDir / tablePath
    let values ← readNaturalTable tablePath (keys.getElems.toList.map TSyntax.getString)
    let terms := values.toArray.map fun n => Syntax.mkNumLit (toString n)
    let term ← `(([$terms,*] : List Nat))
    elabTerm term (some (mkApp (mkConst ``List) (mkConst ``Nat)))

end WeightedRules
