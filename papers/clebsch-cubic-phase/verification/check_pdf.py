"""Reject stale PDFs using a fresh deterministic TeX build and layout checks."""
import hashlib
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT=Path(__file__).resolve().parents[1]
cache=Path(os.environ.get('XDG_CACHE_HOME',Path.home()/'.cache'))/'cubic-phase-replays'
cache.mkdir(parents=True,exist_ok=True)
with tempfile.TemporaryDirectory(prefix='pdf-',dir=cache) as tmp:
    copy=Path(tmp)
    for p in ROOT.glob('*.tex'):shutil.copy2(p,copy/p.name)
    shutil.copytree(ROOT/'sections',copy/'sections');(copy/'build').mkdir()
    env=dict(os.environ,SOURCE_DATE_EPOCH='1788825600',FORCE_SOURCE_DATE='1')
    for i in range(2):
        with (copy/f'pass{i}.log').open('w') as out:
            subprocess.run(['pdflatex','-interaction=nonstopmode','-halt-on-error','-output-directory=build','main.tex'],cwd=copy,env=env,stdout=out,stderr=subprocess.STDOUT,check=True)
    log=(copy/'pass1.log').read_text()
    warnings=[line for line in log.splitlines() if re.search(r'Overfull|Underfull|undefined|LaTeX Warning:',line)]
    assert not warnings,'TeX diagnostics: '+'; '.join(warnings)
    actual=(ROOT/'clebsch-cubic-phase.pdf').read_bytes()
    assert actual==(copy/'build/main.pdf').read_bytes(),'clebsch-cubic-phase.pdf differs from a fresh build; run make pdf'
    print('PASS: byte-identical PDF, no layout/reference warnings; SHA256 '+hashlib.sha256(actual).hexdigest())
