"""Read-only certificate replay for the C956 cold referee report.
Run from the monorepo: uv run --with sympy==1.14.0 python3 notes/2026-09-08-c956-cold-diff-review-check.py
"""
import hashlib, json, subprocess, sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
paper=root/'papers/cubic-stabilization-irrationality'
commands=[
['verification/derive_slice_cover.py','--check-certificate','verification/slice-cover-certificate.json','--check-tex-artifact','verification/slice-cover-values.tex','--check-empty-certificates','verification/groebner-empty-certificates.json'],
['verification/check_slice_cover.py','--check-certificate','verification/slice-cover-certificate.json','--check-empty-certificates','verification/groebner-empty-certificates.json'],
['verification/check_rank_four.py']]
results=[]
for cmd in commands:
 r=subprocess.run([sys.executable,*cmd],cwd=paper,capture_output=True,text=True)
 results.append(dict(command=cmd,returncode=r.returncode,stdout=r.stdout,stderr=r.stderr))
 if r.returncode: break
inputs=sorted({x for cmd in commands for x in cmd if x.startswith('verification/')}|{'verification/rank-four-certificate.json'})
hashes={name:dict(sha256=hashlib.sha256((paper/name).read_bytes()).hexdigest(),bytes=(paper/name).stat().st_size) for name in inputs}
import sympy
out=dict(python=sys.version.split()[0],sympy=sympy.__version__,inputs=hashes,checks=results)
path=Path(__file__).with_name('2026-09-08-c956-cold-diff-review-check.json')
path.write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
print(json.dumps(results,indent=2))
assert len(results)==3 and all(r['returncode']==0 for r in results)
