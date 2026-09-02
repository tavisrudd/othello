#[path = "../q29_mod9_parity_target.rs"]
mod parity_target;

mod q29_mod9_lift {
    pub use ergodis_private::q29_mod9_lift::*;
}

mod q29_parity_support {
    pub use ergodis_private::q29_parity_support::*;
}

use ergodis_private::{
    q29_complete_even_moments::{lift_q29_row0_to_minus9_9, reconstruct_q29_row0_mod29},
    q29_exact_anneal::q29_mod18_shell_level,
    q29_mod9_generator::{generate_q29_mod9_rows_low_lift, Q29Mod9GeneratorWorkspace},
    q29_mod9_lift::{compile_q29_mod9_lift_fibre, Q29Mod9LiftWorkspace},
    q29_parity_support::q29_support_quartet_satisfies_parity,
};
use parity_target::{
    sample_parity_targeted_q29_mod9_lift_with_pool_limit, Q29ParityTargetWorkspace,
};
use std::thread;

const BANK_CAPACITY: usize = 64;

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
    liftable_fibres: u64,
    parity_hits: u64,
    exact_hits: u64,
    reconstructed_bounded: u64,
    reconstructed_mod9: u64,
    reconstructed_parity: u64,
    reconstructed_exact: u64,
    checksum: u64,
    bank: CandidateBank,
    _pad: [u8; 56],
}

impl WorkerReport {
    const fn new() -> Self {
        Self {
            generated: 0,
            liftable_fibres: 0,
            parity_hits: 0,
            exact_hits: 0,
            reconstructed_bounded: 0,
            reconstructed_mod9: 0,
            reconstructed_parity: 0,
            reconstructed_exact: 0,
            checksum: 0,
            bank: CandidateBank::new(),
            _pad: [0; 56],
        }
    }
}

fn main() {
    let workers = argument(1, 1_usize);
    let per_worker = argument(2, 10_000_u64);
    let pool_limit = argument(3, 512_usize);
    assert!((1..=18).contains(&workers));
    assert!((1..=1_024).contains(&pool_limit));

    let mut reports = Vec::with_capacity(workers);
    thread::scope(|scope| {
        let mut handles = Vec::with_capacity(workers);
        for worker in 0..workers {
            let start_seed = worker as u64 * per_worker + 1;
            handles.push(scope.spawn(move || run_worker(start_seed, per_worker, pool_limit)));
        }
        for handle in handles {
            reports.push(handle.join().unwrap());
        }
    });

    let mut merged = WorkerReport::new();
    for report in reports {
        merged.generated += report.generated;
        merged.liftable_fibres += report.liftable_fibres;
        merged.parity_hits += report.parity_hits;
        merged.exact_hits += report.exact_hits;
        merged.reconstructed_bounded += report.reconstructed_bounded;
        merged.reconstructed_mod9 += report.reconstructed_mod9;
        merged.reconstructed_parity += report.reconstructed_parity;
        merged.reconstructed_exact += report.reconstructed_exact;
        merged.checksum = merged.checksum.wrapping_add(report.checksum);
        for &candidate in &report.bank.entries[..report.bank.len] {
            let shell = q29_mod18_shell_level(&candidate.rows).expect("merged direct shell replay");
            assert_eq!(shell.level, candidate.level);
            merged.bank.insert(candidate);
        }
    }

    println!("mode=parity_targeted_fibre_join");
    println!("workers={workers}");
    println!("per_worker={per_worker}");
    println!("pool_limit={pool_limit}");
    println!("generated={}", merged.generated);
    println!("liftable_fibres={}", merged.liftable_fibres);
    println!("parity_hits={}", merged.parity_hits);
    println!("exact_hits={}", merged.exact_hits);
    println!("reconstructed_bounded={}", merged.reconstructed_bounded);
    println!("reconstructed_mod9={}", merged.reconstructed_mod9);
    println!("reconstructed_parity={}", merged.reconstructed_parity);
    println!("reconstructed_exact={}", merged.reconstructed_exact);
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
    println!("checksum={}", merged.checksum);
    println!("per_worker_target_workspace_bytes=49881090");
    println!("per_worker_lift_workspace_bytes=32290005");
    println!("provenance=ObservedParityTargetedPool; exact per-row lift sampler plus bounded MITM parity join; positives directly replayed as mod18 shells; misses have no negative authority");
}

fn run_worker(start_seed: u64, count: u64, pool_limit: usize) -> WorkerReport {
    let mut generator = Q29Mod9GeneratorWorkspace::new().expect("fixed field setup");
    let mut lift = Q29Mod9LiftWorkspace::new();
    let mut parity = Q29ParityTargetWorkspace::new();
    let mut report = WorkerReport::new();
    report.generated = count;
    for seed in start_seed..start_seed + count {
        let generated =
            generate_q29_mod9_rows_low_lift(seed, &mut generator).expect("direct mod9 replay");
        let fibre = compile_q29_mod9_lift_fibre(&generated.rows, &mut lift)
            .expect("bounded integer-lift fibre");
        if fibre.count == 0 {
            continue;
        }
        report.liftable_fibres += 1;
        let mut random = seed ^ 0x6a09_e667_f3bc_c909;
        let Some(witness) = sample_parity_targeted_q29_mod9_lift_with_pool_limit(
            &generated.rows,
            &lift,
            &mut parity,
            &mut random,
            pool_limit,
        )
        .expect("targeted lift replay") else {
            continue;
        };
        report.parity_hits += 1;
        let shell = q29_mod18_shell_level(&witness.rows).expect("direct mod18 shell replay");
        report.exact_hits += u64::from(shell.level == 0);
        let hash = diversity_hash(&witness.rows);
        report.checksum = report.checksum.wrapping_add(hash);
        report.bank.insert(CandidateRecord {
            level: shell.level,
            hash,
            seed,
            rows: witness.rows,
            _pad: [0; 52],
        });
        census_reconstructed_row0(&generated.rows[0], &witness.rows, seed, &mut report);
    }
    report
}

fn census_reconstructed_row0(
    row0_mod9: &[u8; 29],
    sampled: &[[i8; 29]; 4],
    seed: u64,
    report: &mut WorkerReport,
) {
    let mut antisymmetric = [0_i8; 14];
    for representative in 1..=14 {
        antisymmetric[representative - 1] = (i16::from(sampled[0][representative])
            - i16::from(sampled[0][29 - representative]))
            as i8;
    }
    let other_rows = [sampled[1], sampled[2], sampled[3]];
    let Some(reconstructed) = reconstruct_q29_row0_mod29(&other_rows, &antisymmetric) else {
        return;
    };
    let Some(row0) = lift_q29_row0_to_minus9_9(&reconstructed) else {
        return;
    };
    report.reconstructed_bounded += 1;
    if row0
        .iter()
        .zip(row0_mod9)
        .any(|(&value, &residue)| value.rem_euclid(9) as u8 != residue)
    {
        return;
    }
    report.reconstructed_mod9 += 1;
    let rows = [row0, sampled[1], sampled[2], sampled[3]];
    let supports = rows.map(|row| row_support(&row));
    if !q29_support_quartet_satisfies_parity(supports) {
        return;
    }
    report.reconstructed_parity += 1;
    if !replay_exact_q29(&rows) {
        return;
    }
    report.reconstructed_exact += 1;
    let hash = diversity_hash(&rows);
    report.bank.insert(CandidateRecord {
        level: 0,
        hash,
        seed,
        rows,
        _pad: [0; 52],
    });
}

fn row_support(row: &[i8; 29]) -> u32 {
    row.iter()
        .enumerate()
        .fold(0_u32, |support, (column, &value)| {
            support | (u32::from(value & 1 != 0) << column)
        })
}

fn replay_exact_q29(rows: &[[i8; 29]; 4]) -> bool {
    for (block, row) in rows.iter().enumerate() {
        if row.iter().map(|&value| i32::from(value)).sum::<i32>() != i32::from(block == 0) {
            return false;
        }
    }
    (0..29).all(|shift| {
        let mut correlation = 0_i32;
        for row in rows {
            for point in 0..29 {
                correlation += i32::from(row[point]) * i32::from(row[(point + shift) % 29]);
            }
        }
        correlation == if shift == 0 { 505 } else { -18 }
    })
}

fn argument<T: core::str::FromStr>(index: usize, default: T) -> T {
    std::env::args()
        .nth(index)
        .and_then(|value| value.parse().ok())
        .unwrap_or(default)
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn fixed_bank_orders_bounds_and_deduplicates() {
        let mut bank = CandidateBank::new();
        for seed in (0..100).rev() {
            let mut rows = [[0_i8; 29]; 4];
            rows[0][0] = seed as i8;
            bank.insert(CandidateRecord {
                level: seed % 17,
                hash: seed + 1,
                seed,
                rows,
                _pad: [0; 52],
            });
        }
        assert_eq!(bank.len, BANK_CAPACITY);
        assert!(bank.entries[..bank.len]
            .windows(2)
            .all(|pair| pair[0].key() <= pair[1].key()));
        let prior = bank.len;
        bank.insert(bank.entries[0]);
        assert_eq!(bank.len, prior);
    }
}
