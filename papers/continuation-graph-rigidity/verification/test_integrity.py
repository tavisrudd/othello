"""Mutation checks for the paper's source-only metadata gate."""
import contextlib,io,shutil,tempfile
from pathlib import Path
import check_formal_artifact as checker

def rejected():
    try:
        with contextlib.redirect_stdout(io.StringIO()):checker.main()
    except (AssertionError,KeyError):return
    raise AssertionError('mutation was accepted')

def main():
    original=checker.ROOT
    checker.main()
    with tempfile.TemporaryDirectory(prefix='continuation-integrity-') as temp:
        root=Path(temp)
        for name in ('continuation_graph_rigidity.tex','formal-annotations.tex','flake.nix','flake.lock','Makefile'):
            shutil.copy2(original/name,root/name)
        shutil.copytree(original/'verification',root/'verification',ignore=shutil.ignore_patterns('__pycache__'))
        checker.ROOT=root;p=root/'continuation_graph_rigidity.tex';text=p.read_text()
        p.write_text(text.replace(r'\coverage{absent}',r'\coverage{complete}',1));rejected();p.write_text(text)
        p.write_text(text.replace('8&30&144&48&16&2','8&30&72&48&16&2'));rejected();p.write_text(text)
        p.write_text(text.replace(r'\evidence{boundary}',r'\evidence{missing}'));rejected();p.write_text(text)
        p=root/'verification/boundary.json';data=p.read_bytes();p.write_bytes(data+b' ');rejected();p.write_bytes(data)
        checker.ROOT=original
    print('PASS coverage, census-table, evidence-link and certificate mutation rejection')
if __name__=='__main__':main()
