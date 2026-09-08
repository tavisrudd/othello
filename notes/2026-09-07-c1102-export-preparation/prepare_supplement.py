"""One-time, reviewed adoption of existing evidence into the public paper root.
The mapping records provenance; historical evidence authorities are never edited.
"""
from pathlib import Path
import hashlib,json,re,subprocess
REPO=Path(__file__).resolve().parents[2]
PAPER=REPO/'papers/clebsch-cubic-phase'
HERE=Path(__file__).resolve().parent
GROUPS={
 'notes/2026-09-06-clebsch-quantum-replay':'reconstruction',
 'notes/2026-09-07-c1090-resource-classification':'spectra',
 'notes/2026-09-07-c1099-cubic-phase-strengthening':'classification',
 'notes/2026-09-07-c1102-factory-benchmark':'factory'}
old=json.loads((HERE/'original-input-hashes.json').read_text())
record=[]
for name in old:
 source=REPO/name
 group=next((g for g in GROUPS if name.startswith(g+'/')),None)
 if group is None:continue
 rel=name[len(group)+1:]
 if source.suffix not in {'.py','.rs','.toml','.lock','.txt','.json','.pkl'}:continue
 if rel.startswith('astra-bundle/') or rel in {'mkreport.py','memo-data.md'} or '.cargo/' in rel:continue
 # No frozen transcript of the superseded non-equivariance inference is adopted.
 if rel=='paperv/out/step8_torsors.txt':continue
 rel=rel.replace('paperv/','shadow/')
 dest=PAPER/'supplement'/GROUPS[group]/rel
 data=source.read_bytes()
 if source.suffix in {'.py','.rs','.toml','.lock'}:
  s=data.decode()
  if source.suffix=='.py':
   # Discard obsolete scratch and absolute module search paths; use the local supplement.
   s=re.sub(r'^sys\.path\.(?:insert|append)\([^\n]*\n(?:[ \t]+"[^\n]*\n)*', '', s, flags=re.M)
   # The insertion above can span a single line or the original three-line literal.
   if GROUPS[group]=='reconstruction':prefix=''
   elif '/shadow/' in str(dest):prefix='from pathlib import Path\nimport sys\nsys.path.append(str(Path(__file__).resolve().parents[2]/"reconstruction"))\n'
   else:prefix='from pathlib import Path\nimport sys\nsys.path.append(str(Path(__file__).resolve().parents[1]/"reconstruction"))\n'
   # Insert after the module docstring; preserve its role for inspection.
   if prefix:
    if s.startswith('"""'):
     end=s.index('"""',3)+3;s=s[:end]+'\n'+prefix+s[end:]
    else:s=prefix+s
   s=s.replace('REPO = ROOT.parent.parent', 'REPO = ROOT.parents[1]')
   s=s.replace("REPO / 'notes/2026-09-06-clebsch-quantum-replay/common.py'", "REPO / 'supplement/reconstruction/common.py'")
   s=s.replace('os.path.expanduser("~/.cache/ergodis/c1090-target/release/rank11")','str(Path(__file__).resolve().parents[1]/"spectra/rank11/target/release/rank11")')
   s=re.sub(r'EV = "[^"]+"','EV = str(Path(__file__).resolve().parent/"axis")',s)
   s=s.replace('Shared data transcribed from the Clebsch->quantum memo (4 Sept 2026).','Exact signed conic evaluation matrices and finite-field linear algebra.')
  s=s.replace('c1099','conic-search').replace('C1099 / Paper V comparison','chordal restriction comparison').replace('C1099 searches','Conic trade and CSS subspace searches')
  s=s.replace('C1090 report, section 0','Hessian-rank formula in the manuscript').replace('C1090 report','recorded spectrum').replace('C1090','Hessian-rank').replace('Paper V','chordal companion')
  if GROUPS[group]=='factory':
   s=s.replace('notes/2026-09-07-c1102-factory-benchmark/','supplement/factory/')
   s=s.replace("'notes/2026-09-07-c1090-resource-classification/REPORT.md section 4.1'","'manuscript Lemma lem:waring; supplement/spectra/minrank7.txt'")
   s=s.replace("REPO/'notes/2026-09-07-c1090-resource-classification/REPORT.md',\n        REPO/'notes/2026-09-06-clebsch-quantum-replay/astra-bundle/clebsch_quantum_research_memo.md'", "REPO/'sections/03-factory.tex'")
  data=s.encode()
 dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
 record.append({'source':name,'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'target':str(dest.relative_to(PAPER)),'adapted_sha256':hashlib.sha256(data).hexdigest()})
# Explicit extra dependency of the Hankel identification; read-only adoption.
name='papers/chordal-conference-reconstruction/verification/evidence/paper_ii_chordal_axis.json'
src=REPO/name;dest=PAPER/'supplement/classification/shadow/axis/paper_ii_chordal_axis.json';dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(src.read_bytes());record.append({'source':name,'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'target':str(dest.relative_to(PAPER)),'adapted_sha256':hashlib.sha256(dest.read_bytes()).hexdigest()})
(HERE/'adoption-map.json').write_text(json.dumps(record,indent=2,sort_keys=True)+'\n')
print('Adopted',len(record),'explicit evidence files; originals unchanged.')
