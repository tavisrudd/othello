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
        profile pgo-release clean

all: release

fmt:
	cargo fmt

fmt-check:
	cargo fmt --check

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

# strong+ vs strong strength match (colour-balanced).
match:
	RUSTFLAGS="$(RFLAGS)" cargo run --release --example match -- 6 40

# Record a perf profile of the full depth-8 game.
profile:
	RUSTFLAGS="$(RFLAGS)" cargo build --profile profiling --example profile_game
	perf record --call-graph dwarf -o /tmp/othello.perf -- \
	    target/profiling/examples/profile_game 60 8
	perf report -i /tmp/othello.perf --stdio --percent-limit 2 --no-children | \
	    grep -E '\[\.\]' | head

# Profile-guided optimisation: instrument, run the game to collect profiles,
# merge, rebuild with the profile. Needs llvm-profdata (llvm-tools-preview).
pgo-release:
	@test -n "$(LLVM_PROFDATA)" || { echo "llvm-profdata not found: rustup component add llvm-tools-preview"; exit 1; }
	rm -rf $(PROFRAW)
	RUSTFLAGS="$(RFLAGS) -Cprofile-generate=$(PROFRAW)" \
	    cargo build --release --example profile_game
	./target/release/examples/profile_game 80 8 >/dev/null
	"$(LLVM_PROFDATA)" merge -o $(PROFDATA) $(PROFRAW)
	RUSTFLAGS="$(RFLAGS) -Cprofile-use=$(PROFDATA) -Cllvm-args=-pgo-warn-missing-function" \
	    cargo build --release
	@echo "PGO build at target/release/ (run: make bench)"

clean:
	cargo clean
