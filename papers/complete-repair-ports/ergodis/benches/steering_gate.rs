use criterion::{criterion_group, criterion_main, Criterion, Throughput};
use std::hint::black_box;
use std::sync::atomic::{AtomicBool, Ordering};

const STATES: u64 = 1 << 20;
const STRIDE: u64 = 4096;
const HEARTBEAT: u64 = 65536;

#[repr(align(64))]
struct PaddedFlag(AtomicBool);

fn steering_gate(c: &mut Criterion) {
    let flag = PaddedFlag(AtomicBool::new(false));
    let mut group = c.benchmark_group("idle_steering_gate");
    group.throughput(Throughput::Elements(STATES));
    group.bench_function("direct_relaxed_load", |b| {
        b.iter(|| {
            let flag = black_box(&flag);
            let mut hits = 0_u64;
            for _ in 0..STATES {
                hits += u64::from(flag.0.load(Ordering::Relaxed));
            }
            black_box(hits)
        })
    });
    group.bench_function("stride_then_relaxed_load", |b| {
        b.iter(|| {
            let flag = black_box(&flag);
            let mut hits = 0_u64;
            for state in 0..STATES {
                if state & (STRIDE - 1) == 0 {
                    hits += u64::from(flag.0.load(Ordering::Relaxed));
                }
            }
            black_box(hits)
        })
    });
    group.bench_function("heartbeat_deadline", |b| {
        b.iter(|| {
            let mut next = HEARTBEAT;
            let mut events = 0_u64;
            for state in 1..=STATES {
                if state >= next {
                    events += 1;
                    next += HEARTBEAT;
                }
            }
            black_box(events)
        })
    });
    group.bench_function("combined_deadline", |b| {
        b.iter(|| {
            let flag = black_box(&flag);
            let mut next_heartbeat = HEARTBEAT;
            let mut next_steering = STRIDE;
            let mut next_event = next_heartbeat.min(next_steering);
            let mut events = 0_u64;
            for state in 1..=STATES {
                if state >= next_event {
                    if state >= next_steering {
                        events += u64::from(flag.0.load(Ordering::Relaxed));
                        next_steering += STRIDE;
                    }
                    if state >= next_heartbeat {
                        events += 1;
                        next_heartbeat += HEARTBEAT;
                    }
                    next_event = next_heartbeat.min(next_steering);
                }
            }
            black_box(events)
        })
    });
    group.finish();
}

criterion_group!(benches, steering_gate);
criterion_main!(benches);
