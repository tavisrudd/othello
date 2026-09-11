"""Snapshot the bounded Lean trust review; run after the guarded axiom audit."""
import argparse
import ast
from collections import Counter
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import re
import runpy
import tomllib

ROOT = Path(__file__).resolve().parents[1]
PAPER = ROOT / 'papers/cubic-stabilization-m1'
LEAN = PAPER / 'lean'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rational(node):
    if isinstance(node, ast.Constant) and isinstance(node.value, int):
        return Fraction(node.value)
    if (isinstance(node, ast.Call) and isinstance(node.func, ast.Attribute)
            and isinstance(node.func.value, ast.Name) and node.func.value.id == 'sp'
            and node.func.attr == 'Rational' and len(node.args) == 2):
        return Fraction(*(ast.literal_eval(x) for x in node.args))
    raise ValueError(ast.dump(node))


def snapshot(log):
    checker = runpy.run_path(str(LEAN / 'verification/check_formal_artifact.py'))
    expected, observed = checker['expected_axioms'](), checker['observed_axioms'](log)
    assert expected == observed
    assert set().union(*map(set, observed.values())) <= {'propext', 'Classical.choice', 'Quot.sound'}
    source_paths = sorted((LEAN / 'TavisRuddFiniteGeom').rglob('*.lean'))
    sources = {str(p.relative_to(LEAN).with_suffix('')).replace('/', '.'): p for p in source_paths}
    for p in source_paths:
        for label, pattern in checker['FORBIDDEN'].items():
            assert not pattern.search(p.read_text()), (p, label)
    def closure(roots):
        seen, todo = set(), list(roots)
        while todo:
            module = todo.pop()
            if module in seen or module not in sources:
                continue
            seen.add(module)
            todo.extend(re.findall(r'^import\s+(\S+)', sources[module].read_text(), re.M))
        return seen
    cfg = tomllib.loads((LEAN / 'lakefile.toml').read_text())
    claims = json.loads((LEAN / 'verification/claims.json').read_text())
    audit_closure = closure([claims['axiom_audit_module']])
    build_closure = closure(cfg['lean_lib'][0]['roots'])
    main_labels = set()
    for p in (PAPER / 'sections').glob('*.tex'):
        main_labels.update(re.findall(r'\\label\{((?:thm|prop|lem|cor|def):[^}]+)\}', p.read_text()))
    main_claims = [r for r in claims['claims'] if r['manuscript_label'] in main_labels]
    # Parse literal data without executing the SymPy checker or evaluating Lean code.
    nodes = ast.parse((PAPER / 'verification/fano-matrices/finite_checks.py').read_text())
    data = next(n.value for n in nodes.body if isinstance(n, ast.Assign)
                and any(isinstance(t, ast.Name) and t.id == 'DATA' for t in n.targets))
    python_rows = {ast.literal_eval(k): [rational(x) for x in v.elts]
                   for k,v in zip(data.keys, data.values)}
    matrix_source = sources['TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SeventeenCountingMatrices'].read_text()
    rows = re.findall(r'\| \.(\w+) => sixCountingParameters ([^\n]+)', matrix_source)
    assert len(rows) == len(python_rows) == 17
    for label, values in rows:
        key = label.replace('genus', 'g').replace('degree', 'd').replace('projectiveSpace','projective_space')
        parsed = [Fraction(x) for x in re.findall(r'\(([-\d/]+)\)', values)]
        assert parsed == python_rows[key], label
    finite = json.loads((PAPER/'verification/fano-matrices/finite_checks.json').read_text())
    expected_o3 = {'g2': 104, 'g3': 60, 'g4': 40, 'g5': 28}
    assert all(row['O3'] == expected_o3.get(label, 0) for label,row in finite['families'].items())
    reconstruction = json.loads((PAPER/'verification/fano-matrices/reconstruction_check.json').read_text())
    assert reconstruction['inputs']['finite_checks.py'] == sha(PAPER/'verification/fano-matrices/finite_checks.py')
    files = {str(p.relative_to(LEAN)): sha(p) for p in source_paths}
    return {
        'scope': 'Source inventory, guarded-audit transcript comparison, import closure and literal table correspondence; semantic review is in the companion report.',
        'toolchain': (LEAN/'lean-toolchain').read_text().strip(),
        'mathlib_revision': next(p['rev'] for p in json.loads((LEAN/'lake-manifest.json').read_text())['packages'] if p['name']=='mathlib'),
        'project_source_count': len(sources), 'project_source_sha256': files,
        'source_inventory_sha256': hashlib.sha256(''.join(f'{p} {h}\n' for p,h in files.items()).encode()).hexdigest(),
        'audit_log_sha256': sha(log), 'public_terminals': len(observed),
        'axiom_sets': dict(Counter(', '.join(v) or 'none' for v in observed.values())),
        'audit_project_import_closure': len(audit_closure),
        'outside_audit_project_import_closure': sorted(set(sources)-audit_closure),
        'library_project_import_closure': len(build_closure),
        'outside_library_project_import_closure': sorted(set(sources)-build_closure),
        'all_manuscripts_coverage': dict(Counter(r['coverage'] for r in claims['claims'])),
        'primary_manuscript_coverage': dict(Counter(r['coverage'] for r in main_claims)),
        'primary_manuscript_claim_count': len(main_claims),
        'machinery_terminals': len(claims['machinery']),
        'literal_matrix_comparison': '17/17 match the Python evidence inputs exactly',
        'full_odd_dimension_certificate': expected_o3,
        'input_sha256': {str(p.relative_to(ROOT)): sha(p) for p in [LEAN/'verification/claims.json', LEAN/'verification/expected_axioms.txt', LEAN/'verification/check_formal_artifact.py', LEAN/'lakefile.toml', LEAN/'lake-manifest.json', PAPER/'verification/fano-matrices/finite_checks.py', PAPER/'verification/fano-matrices/finite_checks.json', PAPER/'verification/fano-matrices/reconstruction_check.json']},
        'status': 'PASS'
    }


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--axiom-log', type=Path, required=True)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    result = json.dumps(snapshot(args.axiom_log), indent=2, sort_keys=True)+'\n'
    output = Path(__file__).with_suffix('.json')
    if args.check:
        assert output.read_text() == result, 'Review snapshot changed'
    else:
        output.write_text(result)
    print('PASS: source inventory, 371-terminal axiom agreement, coverage and 17 matrix rows.')
