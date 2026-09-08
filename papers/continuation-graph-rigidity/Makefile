.PHONY: check pdf boundary benchmark
check:
	python3 verification/check_formal_artifact.py
	python3 verification/test_integrity.py
	python3 verification/replay_boundary.py
	python3 verification/check_recognition.py
	python3 verification/check_geometric_witnesses.py
pdf:
	python3 verification/check_manuscript_build.py --update
boundary:
	nix shell --inputs-from path:. nixpkgs\#sage --command sage -python verification/generate_boundary.py --check
benchmark:
	nix shell --inputs-from path:. nixpkgs\#sage --command sage -python verification/check_recognition.py --benchmark
