# Othello (Rust) build / bench / quality targets.
#
# target-cpu: pinned to znver5 on Zen 5 AMD hosts (this box: Ryzen AI 9 HX 370)
# for reproducible bench numbers and full AVX-512 coverage; `native` elsewhere.
# We re-add the mold linker because an env RUSTFLAGS *overrides* (does not merge
# with) the [target.*] rustflags in the cargo config that normally sets it.
VENDOR := $(shell grep -m1 '^vendor_id' /proc/cpuinfo 2>/dev/null | awk '{print $$3}')
ifeq ($(VENDOR),AuthenticAMD)
  CPU := -C target-cpu=znver5
else
  CPU := -C target-cpu=native
endif
RFLAGS := $(CPU) -C link-arg=-fuse-ld=mold

PROFRAW := /tmp/othello-pgo
PROFDATA := $(PROFRAW)/merged.profdata
LLVM_PROFDATA ?= $(shell ls $$(rustc --print sysroot)/lib/rustlib/*/bin/llvm-profdata 2>/dev/null | head -1)

.PHONY: all fmt fmt-check clippy build test release bench bench-parallel bench-simd \
        match match-deeper match-plus calibrate-mpc profile install-hooks \
        pgo-check pgo-queens pgo-othello pgo-release clean

all: release

fmt:
	cargo fmt

fmt-check:
	cargo fmt --check

# Install the repo pre-commit hook (auto-fmt staged Rust + clippy gate). Run once
# per clone; the hook lives at <repo>/.githooks/pre-commit (version-controlled).
install-hooks:
	git -C .. config core.hooksPath .githooks
	@echo "pre-commit hook installed (core.hooksPath -> .githooks)"

clippy:
	cargo clippy --all-targets -- -D warnings

build:
	cargo build

test:
	cargo test --release

# Optimised build pinned to the host micro-arch.
release:
	RUSTFLAGS="$(RFLAGS)" cargo build --release

# Headline benchmark: single depth-8 search, depth-8 best_move, full depth-8 game.
bench: release
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example bench

# Same, pinned to the fast Zen 5 CCX (cores 0-3 @ 5.16 GHz) for reproducible
# numbers -- the scheduler usually picks a perf core, but a stray Zen5c (3.29
# GHz) placement costs ~1.5x. taskset removes that variance.
bench-pinned: release
	RUSTFLAGS="$(RFLAGS)" cargo build --release --example bench
	taskset -c 0-3 target/release/examples/bench

# Parallel scaling of the exact-scores path (1..16 workers).
bench-parallel:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example bench_parallel

# SIMD kernel validation + microbench.
bench-simd:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example bench_simd

# Flip-kernel validation + microbench (the "outflank" experiment).
bench-flips:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example bench_flips

# Exact endgame solver (--depth full) timing by empty count.
bench-solve:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example bench_solve

# Full-game benchmark with search isolated from TTY I/O (buffered render).
# OTHELLO_TRACE=1 adds per-move `tracing` spans.
bench-game:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example bench_game

# strong++ vs strong+ strength match (colour-balanced, iso-depth: shows
# Multi-ProbCut is strength-neutral per depth). `match-deeper` gives strong++ the
# extra ply its speed buys; `match-plus` is the eval upgrade (strong+ vs strong).
match:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example match -- 8 40 strong++ strong+

match-deeper:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example match -- 9 40 strong++ strong+ 8

match-plus:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example match -- 6 40 strong+ strong

# Regenerate the Multi-ProbCut coefficient table (paste stdout into src/mpc.rs).
calibrate-mpc:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example calibrate_mpc -- 3000 1

# Record a perf profile of the full depth-8 game.
profile:
	RUSTFLAGS="$(RFLAGS)" cargo build --profile profiling --example profile_game
	perf record --call-graph dwarf -o /tmp/othello.perf -- \
	    target/profiling/examples/profile_game 60 8
	perf report -i /tmp/othello.perf --stdio --percent-limit 2 --no-children | \
	    grep -E '\[\.\]' | head

# Profile-guided optimisation: build instrumented, run a representative workload
# to collect profiles, merge, then rebuild with the profile applied. Needs
# llvm-profdata (rustup component add llvm-tools-preview).
#
# Isolated target dirs so PGO never fights the plain `make release` cache and the
# two passes don't clobber each other:
#   target/pgo-instrumented/release/   -- the -Cprofile-generate binaries
#   target/pgo-release/release/        -- the final -Cprofile-use binaries (use these)
# `make release` keeps target/release/ to itself.
#
# Queens profiles the n=14 search (deepest board that reaches the n=16 regime
# quickly) but SIGINT-terminates it after PGO_SECS: the instrumented binary is far
# slower (per-edge counter overhead), so a full n=14 solve would take minutes,
# while a time-boxed partial run already exercises every hot function at
# representative branch frequencies (PGO weights frequencies, not wall-clock). The
# queens SIGINT handler exits via `std::process::exit`, which runs the LLVM profile
# atexit writer, so the .profraw flushes cleanly on the interrupt (verified); the
# `|| true` swallows timeout's expected non-zero exit. Othello profiles a full
# depth-8 game. `pgo-release` merges both workloads into one profile.
PGO_INSTR := target/pgo-instrumented
PGO_OUT   := target/pgo-release
PGO_SECS  ?= 12

pgo-check:
	@test -n "$(LLVM_PROFDATA)" || { echo "llvm-profdata not found: rustup component add llvm-tools-preview"; exit 1; }

# PGO the queens solver, profiled on a time-boxed n=14 search with the `incremental`
# solver -- the DFS-resident incremental-canon hot path we want PGO to optimise for.
pgo-queens: pgo-check
	rm -rf $(PROFRAW)
	RUSTFLAGS="$(RFLAGS) -Cprofile-generate=$(PROFRAW)" \
	    cargo build --release --bin queens --target-dir $(PGO_INSTR)
#	timeout -s INT $(PGO_SECS) $(PGO_INSTR)/release/queens solve 14 incremental >/dev/null 2>&1 || true
#	timeout -s INT $(PGO_SECS) $(PGO_INSTR)/release/queens solve 14 burr >/dev/null 2>&1 || true
#	timeout -s INT $(PGO_SECS) $(PGO_INSTR)/release/queens solve 14 fused >/dev/null 2>&1 || true
#	timeout -s INT $(PGO_SECS) $(PGO_INSTR)/release/queens solve 14 iso-burr >/dev/null 2>&1 || true
	timeout -s INT $(PGO_SECS) $(PGO_INSTR)/release/queens solve 14 iso-flat >/dev/null 2>&1 || true
	timeout -s INT $(PGO_SECS) $(PGO_INSTR)/release/queens solve 14 iso-window >/dev/null 2>&1 || true
	timeout -s INT $(PGO_SECS) $(PGO_INSTR)/release/queens solve 14 iso-dense >/dev/null 2>&1 || true
	"$(LLVM_PROFDATA)" merge -o $(PROFDATA) $(PROFRAW)
	RUSTFLAGS="$(RFLAGS) -Cprofile-use=$(PROFDATA) -Cllvm-args=-pgo-warn-missing-function" \
	    cargo build --release --bin queens --target-dir $(PGO_OUT)
	@echo "PGO queens at $(PGO_OUT)/release/queens (profiled: solve 14 incremental, $(PGO_SECS)s)"

# PGO the othello engine, profiled on a full depth-8 game.
pgo-othello: pgo-check
	rm -rf $(PROFRAW)
	RUSTFLAGS="$(RFLAGS) -Cprofile-generate=$(PROFRAW)" \
	    cargo build --release --example profile_game --target-dir $(PGO_INSTR)
	$(PGO_INSTR)/release/examples/profile_game 80 8 >/dev/null
	"$(LLVM_PROFDATA)" merge -o $(PROFDATA) $(PROFRAW)
	RUSTFLAGS="$(RFLAGS) -Cprofile-use=$(PROFDATA) -Cllvm-args=-pgo-warn-missing-function" \
	    cargo build --release --target-dir $(PGO_OUT)
	@echo "PGO othello at $(PGO_OUT)/release/ (profiled: profile_game 80 8)"

# PGO both binaries from one merged profile: instrument once, run the time-boxed
# n=14 queens solve AND a depth-8 othello game, merge their .profraw, rebuild both.
pgo-release: pgo-check
	rm -rf $(PROFRAW)
	RUSTFLAGS="$(RFLAGS) -Cprofile-generate=$(PROFRAW)" \
	    cargo build --release --bin queens --example profile_game --target-dir $(PGO_INSTR)
	timeout -s INT $(PGO_SECS) $(PGO_INSTR)/release/queens solve 14 incremental >/dev/null 2>&1 || true
	$(PGO_INSTR)/release/examples/profile_game 80 8 >/dev/null
	"$(LLVM_PROFDATA)" merge -o $(PROFDATA) $(PROFRAW)
	RUSTFLAGS="$(RFLAGS) -Cprofile-use=$(PROFDATA) -Cllvm-args=-pgo-warn-missing-function" \
	    cargo build --release --target-dir $(PGO_OUT)
	@echo "PGO build at $(PGO_OUT)/release/ (profiled: queens solve 14 incremental [$(PGO_SECS)s] + othello profile_game)"

clean:
	cargo clean
	rm -rf $(PROFRAW)
