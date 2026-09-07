"""Refresh the public evidence hash and byte-count manifest after validation."""
import hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
if __name__=='__main__':
    paths=[ROOT/'continuation_graph_rigidity.tex',ROOT/'formal-annotations.tex',ROOT/'flake.nix',ROOT/'flake.lock',ROOT/'Makefile']
    paths+=sorted((ROOT/'verification').glob('*.py'))
    paths+=sorted(p for p in (ROOT/'verification').glob('*.json') if p.name!='file-sizes.json')
    paths+=[ROOT/'verification/dependency-graph.dot']
    lines=[];sizes={}
    for p in sorted(paths):
        name=p.relative_to(ROOT).as_posix();data=p.read_bytes()
        lines.append(hashlib.sha256(data).hexdigest()+'  '+name);sizes[name]=len(data)
    (ROOT/'verification/file-sizes.json').write_text(json.dumps(sizes,indent=2,sort_keys=True)+'\n')
    p=ROOT/'verification/file-sizes.json'
    lines.append(hashlib.sha256(p.read_bytes()).hexdigest()+'  verification/file-sizes.json')
    (ROOT/'verification/SHA256SUMS').write_text('\n'.join(lines)+'\n')
