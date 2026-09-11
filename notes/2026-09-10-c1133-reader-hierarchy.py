"""Replay the bounded reader-hierarchy revision checks (PyMuPDF 1.28.2)."""
import argparse
import ast
from fractions import Fraction as F
import hashlib
import json
from pathlib import Path
import re
import pymupdf

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--check', action='store_true')
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
paper = root / 'papers/cubic-stabilization-m1'
title = 'One-stabilization irrationality and Hodge conservation for Fano threefolds'
source = (paper/'cubic_stabilization_m1.tex').read_text()
assert '\\title{' + title + '}' in source
abstract = source.split('\\begin{abstract}', 1)[1].split('\\end{abstract}', 1)[0]
assert len(abstract.split()) <= 200
assert json.loads((paper/'.zenodo.json').read_text())['title'] == title
assert title in (root/'papers/summary/README.md').read_text()
node = ast.parse((paper/'verification/fano-matrices/finite_checks.py').read_text())
data = next(n.value for n in node.body if isinstance(n, ast.Assign) and any(isinstance(t, ast.Name) and t.id == 'DATA' for t in n.targets))
row = next(ast.literal_eval(v) for k,v in zip(data.keys,data.values) if ast.literal_eval(k)=='d2')
assert row == [0,0,48,160,0,2304] or row == (0,0,48,160,0,2304)
a,b = map(F,row[2:4]);s=2*a+b
residue = [-(2*a+3*b)/(2*s), F(1), -4*a*a/(s*s), (b-2*a)/(2*s)]
assert residue == [F(-9,8),F(1),F(-9,64),F(1,8)]
trace=residue[0]+residue[3];det=residue[0]*residue[3]-residue[1]*residue[2]
assert trace == -1 and det == 0 and trace*trace-4*det == 1
files = [paper/'cubic_stabilization_m1.tex',paper/'.zenodo.json',paper/'README.md',root/'papers/summary/README.md',paper/'verification/fano-matrices/finite_checks.py']
files += sorted((paper/'sections').glob('*.tex'))
pdfs = [paper/'irrationality_after_one_stabilization.pdf',paper/'companions/six-axis-cubic-pencil/six_axis_cubic_pencil.pdf',paper/'companions/cubic-framed-monodromy/cubic_framed_monodromy.pdf']
files += pdfs
result = {'status':'PASS','title':title,'abstract_whitespace_words':len(abstract.split()),'degree_two_residue':[str(x) for x in residue],'residue_trace':str(trace),'residue_determinant':str(det),'residue_discriminant':'1','pdf_pages':{str(p.relative_to(root)):len(pymupdf.open(p)) for p in pdfs},'sha256':{str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}}
text=json.dumps(result,indent=2,sort_keys=True)+'\n'
output=Path(__file__).with_suffix('.json')
if args.check:
    assert output.read_text()==text, 'Editorial snapshot changed'
else:
    output.write_text(text)
print('PASS: title, abstract limit, exact resonant example, source/PDF identity.')
