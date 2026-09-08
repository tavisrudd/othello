.PHONY: check pdf pdf-check
check:
	python3 verification/check_metadata.py
	python3 verification/check.py
	python3 verification/finite_check.py --check
	python3 verification/shadow_check.py --check
	python3 supplement/factory/benchmark.py --check
pdf: check
	mkdir -p build
	SOURCE_DATE_EPOCH=1788825600 FORCE_SOURCE_DATE=1 pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build main.tex > build/pass1.log
	SOURCE_DATE_EPOCH=1788825600 FORCE_SOURCE_DATE=1 pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build main.tex > build/pass2.log
	cp build/main.pdf companion.pdf

pdf-check: check
	python3 verification/check_pdf.py
