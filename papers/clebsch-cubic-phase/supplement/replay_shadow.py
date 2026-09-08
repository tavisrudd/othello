"""Replay the chordal restriction in an isolated copy; retain exact outputs."""
from pathlib import Path
import os
import shutil
import subprocess
import sys
import tempfile

ROOT=Path(__file__).resolve().parents[1]
cache=Path(os.environ.get('XDG_CACHE_HOME',Path.home()/'.cache'))/'cubic-phase-replays'
cache.mkdir(parents=True,exist_ok=True)
with tempfile.TemporaryDirectory(prefix='shadow-',dir=cache) as tmp:
    copy=Path(tmp)/'artifact'
    shutil.copytree(ROOT/'supplement',copy/'supplement',ignore=shutil.ignore_patterns('target','__pycache__'))
    shutil.copytree(ROOT/'verification',copy/'verification',ignore=shutil.ignore_patterns('__pycache__'))
    work=copy/'supplement/classification/shadow'
    for name in ['step1_config','step2_action','step3_decomp','step4_bridge','step5_pencil','step6_identify','step7_invariants','step8_torsors','step9_survey']:
        log=cache/(name+'.log')
        with log.open('w') as out:
            subprocess.run([sys.executable,str(work/(name+'.py'))],cwd=work,stdout=out,stderr=subprocess.STDOUT,check=True)
        print(name+': PASS',flush=True)
    subprocess.run([sys.executable,str(copy/'verification/shadow_check.py'),'--check'],check=True)
print('PASS: shadow regenerated in isolation; exact coefficient certificate agrees.')
