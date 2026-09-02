use ergodis_private::{
    q29_exact_anneal::{anneal_q29_from_mod18, q29_mod18_shell_level, Q29AnnealReport},
    q29_mod9_generator::{generate_q29_mod9_rows_low_lift, Q29Mod9GeneratorWorkspace},
    q29_mod9_lift::{
        compile_q29_mod9_lift_fibre, sample_distinct_q29_mod9_lifts, Q29Mod9LiftWitness,
        Q29Mod9LiftWorkspace,
    },
};
use std::thread;

const BANK_CAPACITY: usize = 64;
const MAX_SAMPLES_PER_FIBRE: usize = 64;
const LOG_BUCKETS: usize = 129;

#[derive(Clone, Copy)]
struct AnnealWorkerReport {
    tasks: u64,
    exact_hits: u64,
    best: Option<Q29AnnealReport>,
}

impl AnnealWorkerReport {
    const EMPTY: Self = Self {
        tasks: 0,
        exact_hits: 0,
        best: None,
    };
}

#[repr(C, align(64))]
#[derive(Clone, Copy)]
struct CandidateRecord {
    level: u64,
    hash: u64,
    seed: u64,
    rows: [[i8; 29]; 4],
    _pad: [u8; 52],
}

const _: () = assert!(core::mem::size_of::<CandidateRecord>() == 192);

impl CandidateRecord {
    const EMPTY: Self = Self {
        level: u64::MAX,
        hash: u64::MAX,
        seed: u64::MAX,
        rows: [[0; 29]; 4],
        _pad: [0; 52],
    };

    fn key(&self) -> (u64, u64, u64) {
        (self.level, self.hash, self.seed)
    }
}

#[repr(C, align(64))]
#[derive(Clone, Copy)]
struct CandidateBank {
    entries: [CandidateRecord; BANK_CAPACITY],
    len: usize,
    _pad: [u8; 56],
}

impl CandidateBank {
    const fn new() -> Self {
        Self {
            entries: [CandidateRecord::EMPTY; BANK_CAPACITY],
            len: 0,
            _pad: [0; 56],
        }
    }

    fn insert(&mut self, candidate: CandidateRecord) {
        for existing in &self.entries[..self.len] {
            if existing.hash == candidate.hash && existing.rows == candidate.rows {
                return;
            }
        }
        let mut position = 0;
        while position < self.len && self.entries[position].key() <= candidate.key() {
            position += 1;
        }
        if position == BANK_CAPACITY {
            return;
        }
        let new_len = (self.len + 1).min(BANK_CAPACITY);
        let mut index = new_len - 1;
        while index > position {
            self.entries[index] = self.entries[index - 1];
            index -= 1;
        }
        self.entries[position] = candidate;
        self.len = new_len;
    }
}

#[repr(C, align(64))]
#[derive(Clone, Copy)]
struct WorkerReport {
    generated: u64,
    minimum_energy_survivors: u64,
    liftable_fibres: u64,
    sampled_lifts: u64,
    parity_hits: u64,
    exact_q29_hits: u64,
    saturated_fibres: u64,
    fibre_count_log2: [u64; LOG_BUCKETS],
    level_log2: [u64; LOG_BUCKETS],
    minimum_level: u64,
    maximum_level: u64,
    checksum: u64,
    bank: CandidateBank,
}

const _: () = assert!(core::mem::align_of::<WorkerReport>() == 64);

fn main() {
    let workers = std::env::args()
        .nth(1)
        .and_then(|value| value.parse::<usize>().ok())
        .unwrap_or(1);
    let per_worker = std::env::args()
        .nth(2)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(100_000);
    let samples_per_fibre = std::env::args()
        .nth(3)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(1);
    let anneal_tasks = std::env::args()
        .nth(4)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(0);
    let anneal_mutations = std::env::args()
        .nth(5)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(0);
    assert!((1..=18).contains(&workers));
    assert!(samples_per_fibre != 0);
    let mut reports = Vec::with_capacity(workers);
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(workers);
        for worker in 0..workers {
            let start_seed = worker as u64 * per_worker + 1;
            handles
                .push(scope.spawn(move || run_worker(start_seed, per_worker, samples_per_fibre)));
        }
        for handle in handles {
            reports.push(handle.join().unwrap());
        }
    });
    let mut merged = WorkerReport::empty();
    for report in &reports {
        merged.generated += report.generated;
        merged.minimum_energy_survivors += report.minimum_energy_survivors;
        merged.liftable_fibres += report.liftable_fibres;
        merged.sampled_lifts += report.sampled_lifts;
        merged.parity_hits += report.parity_hits;
        merged.exact_q29_hits += report.exact_q29_hits;
        merged.saturated_fibres += report.saturated_fibres;
        for index in 0..LOG_BUCKETS {
            merged.fibre_count_log2[index] += report.fibre_count_log2[index];
            merged.level_log2[index] += report.level_log2[index];
        }
        merged.minimum_level = merged.minimum_level.min(report.minimum_level);
        merged.maximum_level = merged.maximum_level.max(report.maximum_level);
        merged.checksum = merged.checksum.wrapping_add(report.checksum);
        for &candidate in &report.bank.entries[..report.bank.len] {
            assert!(replay_parity(&candidate.rows));
            let shell = q29_mod18_shell_level(&candidate.rows).expect("direct shell replay");
            assert_eq!(shell.level, candidate.level);
            merged.bank.insert(candidate);
        }
    }
    println!("workers={workers}");
    println!("per_worker={per_worker}");
    println!("samples_per_fibre={samples_per_fibre}");
    println!("generated={}", merged.generated);
    println!(
        "minimum_energy_survivors={}",
        merged.minimum_energy_survivors
    );
    println!("liftable_fibres={}", merged.liftable_fibres);
    println!("sampled_lifts={}", merged.sampled_lifts);
    println!("parity_hits={}", merged.parity_hits);
    println!("saturated_fibres={}", merged.saturated_fibres);
    print_nonzero_buckets("fibre_count_log2", &merged.fibre_count_log2);
    print_nonzero_buckets("level_log2", &merged.level_log2);
    if merged.parity_hits != 0 {
        println!("minimum_level={}", merged.minimum_level);
        println!("maximum_level={}", merged.maximum_level);
    }
    println!("bank_count={}", merged.bank.len);
    for (index, candidate) in merged.bank.entries[..merged.bank.len].iter().enumerate() {
        let shell = q29_mod18_shell_level(&candidate.rows).expect("final direct shell replay");
        println!(
            "candidate_{index}=level:{} score_y:{} score_x:{} seed:{} hash:{:016x} rows:{:?}",
            shell.level,
            shell.exact_score_y,
            shell.exact_score_x,
            candidate.seed,
            candidate.hash,
            candidate.rows
        );
    }
    println!("exact_q29_hits={}", merged.exact_q29_hits);
    println!("checksum={}", merged.checksum);
    println!("provenance=ObservedSampledLowLift; disjoint seed ranges; RandomNormLowLiftHensel policy; fixed top-64 unique rows ordered by shell level/hash/seed (no distance claim); every retained row directly replayed mod2+mod9+integer shell; saturated fibres, if any, are sampled nonuniformly; misses have no negative authority");
    if anneal_tasks != 0 {
        let anneal = run_anneal_campaign(&merged.bank, workers, anneal_tasks, anneal_mutations);
        println!("anneal_tasks_requested={anneal_tasks}");
        println!("anneal_tasks_completed={}", anneal.tasks);
        println!("anneal_mutations_per_task={anneal_mutations}");
        println!("anneal_exact_hits={}", anneal.exact_hits);
        if let Some(best) = anneal.best {
            println!("anneal_best_score_y={}", best.best_score_y);
            println!("anneal_best_score_x={}", best.best_score_x);
            println!("anneal_best_exact_hit={}", best.exact_hit);
            println!("anneal_best_rows={:?}", best.rows);
        }
        println!("anneal_provenance=HeuristicSearch; tasks are deterministic strided reuses of directly replayed top-bank mod18 seeds; every reported exact hit is directly replayed; misses have no negative authority");
    }
}

fn run_anneal_campaign(
    bank: &CandidateBank,
    workers: usize,
    task_count: u64,
    mutations: u64,
) -> AnnealWorkerReport {
    if bank.len == 0 || task_count == 0 {
        return AnnealWorkerReport::EMPTY;
    }
    let active_workers = workers.min(task_count as usize);
    let bank = *bank;
    let mut reports = Vec::with_capacity(active_workers);
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(active_workers);
        for worker in 0..active_workers {
            handles.push(scope.spawn(move || {
                let mut report = AnnealWorkerReport::EMPTY;
                let mut task = worker as u64;
                while task < task_count {
                    let candidate = bank.entries[task as usize % bank.len];
                    let random_seed = candidate.seed
                        ^ task.wrapping_mul(0x9e37_79b9_7f4a_7c15)
                        ^ 0xd1b5_4a32_d192_ed03;
                    let random_seed = if random_seed == 0 {
                        0xa076_1d64_78bd_642f
                    } else {
                        random_seed
                    };
                    let result = if task & 1 == 0 {
                        anneal_q29_from_mod18::<true>(&candidate.rows, random_seed, mutations)
                    } else {
                        anneal_q29_from_mod18::<false>(&candidate.rows, random_seed, mutations)
                    };
                    if result.exact_hit {
                        assert!(replay_exact_q29(&result.rows));
                        report.exact_hits += 1;
                    }
                    report.tasks += 1;
                    if report
                        .best
                        .as_ref()
                        .is_none_or(|best| result.best_score_y < best.best_score_y)
                    {
                        report.best = Some(result);
                    }
                    task += active_workers as u64;
                }
                report
            }));
        }
        for handle in handles {
            reports.push(handle.join().unwrap());
        }
    });
    let mut merged = AnnealWorkerReport::EMPTY;
    for report in reports {
        merged.tasks += report.tasks;
        merged.exact_hits += report.exact_hits;
        if let Some(candidate) = report.best {
            if merged
                .best
                .as_ref()
                .is_none_or(|best| candidate.best_score_y < best.best_score_y)
            {
                merged.best = Some(candidate);
            }
        }
    }
    merged
}

impl WorkerReport {
    const fn empty() -> Self {
        Self {
            generated: 0,
            minimum_energy_survivors: 0,
            liftable_fibres: 0,
            sampled_lifts: 0,
            parity_hits: 0,
            exact_q29_hits: 0,
            saturated_fibres: 0,
            fibre_count_log2: [0; LOG_BUCKETS],
            level_log2: [0; LOG_BUCKETS],
            minimum_level: u64::MAX,
            maximum_level: 0,
            checksum: 0,
            bank: CandidateBank::new(),
        }
    }
}

fn run_worker(start_seed: u64, count: u64, samples_per_fibre: u64) -> WorkerReport {
    let mut generator = Q29Mod9GeneratorWorkspace::new().expect("fixed field setup");
    let mut lift = Q29Mod9LiftWorkspace::new();
    let mut report = WorkerReport::empty();
    report.generated = count;
    for seed in start_seed..start_seed + count {
        let generated =
            generate_q29_mod9_rows_low_lift(seed, &mut generator).expect("direct mod9 replay");
        if minimum_lift_energy(&generated.rows) > 505 {
            continue;
        }
        report.minimum_energy_survivors += 1;
        let fibre = compile_q29_mod9_lift_fibre(&generated.rows, &mut lift)
            .expect("bounded integer-lift fibre");
        if fibre.count != 0 {
            report.liftable_fibres += 1;
            report.saturated_fibres += u64::from(fibre.saturated);
            report.fibre_count_log2[log2_bucket(fibre.count)] += 1;
            let sample_count = if fibre.saturated {
                samples_per_fibre
            } else {
                samples_per_fibre.min(fibre.count.min(u128::from(u64::MAX)) as u64)
            }
            .min(MAX_SAMPLES_PER_FIBRE as u64) as usize;
            let mut random = seed ^ 0xd1b5_4a32_d192_ed03;
            if random == 0 {
                random = 0x9e37_79b9_7f4a_7c15;
            }
            let mut sampled = [Q29Mod9LiftWitness::ZERO; MAX_SAMPLES_PER_FIBRE];
            let produced = sample_distinct_q29_mod9_lifts(
                &generated.rows,
                &lift,
                &mut random,
                &mut sampled[..sample_count],
            )
            .expect("compiled fibre sample");
            for &witness in &sampled[..produced] {
                report.sampled_lifts += 1;
                let parity = replay_parity(&witness.rows);
                report.parity_hits += u64::from(parity);
                if parity {
                    let shell = q29_mod18_shell_level(&witness.rows).expect("direct shell replay");
                    report.level_log2[log2_bucket(u128::from(shell.level))] += 1;
                    report.minimum_level = report.minimum_level.min(shell.level);
                    report.maximum_level = report.maximum_level.max(shell.level);
                    report.bank.insert(CandidateRecord {
                        level: shell.level,
                        hash: diversity_hash(&witness.rows),
                        seed,
                        rows: witness.rows,
                        _pad: [0; 52],
                    });
                }
                let exact = replay_exact_q29(&witness.rows);
                report.exact_q29_hits += u64::from(exact);
                report.checksum = report
                    .checksum
                    .wrapping_add(u64::from(witness.rows[0][0] as u8));
            }
        }
    }
    report
}

fn log2_bucket(value: u128) -> usize {
    if value == 0 {
        0
    } else {
        (u128::BITS - value.leading_zeros()) as usize
    }
}

fn print_nonzero_buckets(label: &str, buckets: &[u64; LOG_BUCKETS]) {
    print!("{label}=");
    let mut separator = "";
    for (index, &count) in buckets.iter().enumerate() {
        if count != 0 {
            print!("{separator}{index}:{count}");
            separator = ",";
        }
    }
    println!();
}

fn diversity_hash(rows: &[[i8; 29]; 4]) -> u64 {
    let mut hash = 0xcbf2_9ce4_8422_2325_u64;
    for row in rows {
        for &value in row {
            hash ^= u64::from(value as u8);
            hash = hash.wrapping_mul(0x0000_0100_0000_01b3);
        }
    }
    hash
}

fn minimum_lift_energy(rows: &[[u8; 29]; 4]) -> u32 {
    let mut total = 0_u32;
    for row in rows {
        for &residue in row {
            let magnitude = u32::from(residue.min(9 - residue));
            total += magnitude * magnitude;
        }
    }
    total
}

fn combined_correlation(rows: &[[i8; 29]; 4], shift: usize) -> i32 {
    let mut total = 0_i32;
    for row in rows {
        for point in 0..29 {
            total += i32::from(row[point]) * i32::from(row[(point + shift) % 29]);
        }
    }
    total
}

fn replay_parity(rows: &[[i8; 29]; 4]) -> bool {
    (0..29).all(|shift| combined_correlation(rows, shift).rem_euclid(2) == i32::from(shift == 0))
}

fn replay_exact_q29(rows: &[[i8; 29]; 4]) -> bool {
    (0..29).all(|shift| combined_correlation(rows, shift) == if shift == 0 { 505 } else { -18 })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn candidate(level: u64, hash: u64, seed: u64) -> CandidateRecord {
        let mut rows = [[0_i8; 29]; 4];
        rows[0][0] = seed as i8;
        CandidateRecord {
            level,
            hash,
            seed,
            rows,
            _pad: [0; 52],
        }
    }

    #[test]
    fn fixed_bank_orders_bounds_and_deduplicates() {
        let mut bank = CandidateBank::new();
        for seed in (0..100).rev() {
            bank.insert(candidate(seed % 17, seed + 1, seed));
        }
        assert_eq!(bank.len, BANK_CAPACITY);
        assert!(bank.entries[..bank.len]
            .windows(2)
            .all(|pair| pair[0].key() <= pair[1].key()));
        let prior = bank.len;
        bank.insert(bank.entries[0]);
        assert_eq!(bank.len, prior);
    }

    #[test]
    fn anneal_handoff_distributes_and_replays_bank_tasks() {
        let rows = ergodis_private::q29_exact_anneal::retained_mod18_seed_17737406();
        let shell = q29_mod18_shell_level(&rows).expect("retained mod18 shell");
        let mut bank = CandidateBank::new();
        bank.insert(CandidateRecord {
            level: shell.level,
            hash: diversity_hash(&rows),
            seed: 17_737_406,
            rows,
            _pad: [0; 52],
        });

        let report = run_anneal_campaign(&bank, 2, 3, 0);
        assert_eq!(report.tasks, 3);
        assert_eq!(report.exact_hits, 0);
        let best = report.best.expect("one retained worker report");
        assert_eq!(best.best_score_y, shell.exact_score_y);
        assert!(!best.exact_hit);
    }
}
