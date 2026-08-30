//! Exact value-set 9-compression for the unresolved order-three multiplier.
//!
//! For subgroup ID 3 of the length-333 Legendre-pair problem, the mod-37
//! multiplier image has order three.  Every compressed entry therefore lies
//! in `V_3`.  The total energy bound removes values of magnitude at least 25.
//! A sequence is observed only through its energy and four cyclic PAF values;
//! cyclic rotations are exact semantic symmetries.  Enumeration is iterative,
//! and the hot path writes into one pre-sized record array.

use std::io::{BufWriter, Write};

const LENGTH: usize = 9;
const TARGET_ENERGY: i16 = 594;
const TARGET_PAF: i16 = -74;
const VALUES: [i16; 16] = [
    -23, -19, -17, -13, -11, -7, -5, -1, 1, 5, 7, 11, 13, 17, 19, 23,
];
const SUM_RADIUS: usize = LENGTH * 23;
const SUM_WIDTH: usize = 2 * SUM_RADIUS + 1;
const RECORD_CAPACITY: usize = 1_951_427;

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Signature {
    energy: i16,
    paf: [i16; 4],
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Record {
    signature: Signature,
    packed: u64,
}

fn sum_slot(sum: i16) -> Option<usize> {
    let shifted = i32::from(sum) + SUM_RADIUS as i32;
    usize::try_from(shifted)
        .ok()
        .filter(|&slot| slot < SUM_WIDTH)
}

fn minimum_energies() -> [[i16; SUM_WIDTH]; LENGTH + 1] {
    let mut table = [[i16::MAX; SUM_WIDTH]; LENGTH + 1];
    table[0][SUM_RADIUS] = 0;
    for count in 1..=LENGTH {
        for sum in -(SUM_RADIUS as i16)..=SUM_RADIUS as i16 {
            let Some(slot) = sum_slot(sum) else {
                continue;
            };
            for &value in &VALUES {
                let Some(prior_slot) = sum_slot(sum - value) else {
                    continue;
                };
                let prior = table[count - 1][prior_slot];
                if prior == i16::MAX {
                    continue;
                }
                table[count][slot] = table[count][slot].min(prior + value * value);
            }
        }
    }
    table
}

#[inline]
fn is_canonical_rotation(sequence: &[i16; LENGTH]) -> bool {
    for shift in 1..LENGTH {
        for index in 0..LENGTH {
            let candidate = sequence[(index + shift) % LENGTH];
            if candidate < sequence[index] {
                return false;
            }
            if candidate > sequence[index] {
                break;
            }
        }
    }
    true
}

#[inline]
fn signature(sequence: &[i16; LENGTH], energy: i16) -> Signature {
    let mut paf = [0_i16; 4];
    for (shift, output) in paf.iter_mut().enumerate() {
        let distance = shift + 1;
        let mut total = 0_i16;
        for index in 0..LENGTH {
            total += sequence[index] * sequence[(index + distance) % LENGTH];
        }
        *output = total;
    }
    Signature { energy, paf }
}

#[inline]
fn pack(indices: &[u8; LENGTH]) -> u64 {
    indices
        .iter()
        .enumerate()
        .fold(0_u64, |word, (position, &index)| {
            word | (u64::from(index) << (4 * position))
        })
}

fn unpack(packed: u64) -> [i16; LENGTH] {
    std::array::from_fn(|position| VALUES[((packed >> (4 * position)) & 15) as usize])
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let minimum_energy = minimum_energies();
    let mut partner_energy = [false; TARGET_ENERGY as usize + 1];
    for energy in 0..=TARGET_ENERGY {
        partner_energy[energy as usize] = minimum_energy[LENGTH][sum_slot(1).unwrap()] <= energy;
    }

    let mut records = Vec::with_capacity(RECORD_CAPACITY);
    let mut sequence = [0_i16; LENGTH];
    let mut indices = [0_u8; LENGTH];
    let mut next = [0_u8; LENGTH];
    let mut prefix_sum = [0_i16; LENGTH + 1];
    let mut prefix_energy = [0_i16; LENGTH + 1];
    let mut depth = 0_usize;
    let mut complete = 0_u64;

    loop {
        if depth == LENGTH {
            complete += 1;
            let energy = prefix_energy[depth];
            let complement = TARGET_ENERGY - energy;
            if complement >= 0
                && partner_energy[complement as usize]
                && is_canonical_rotation(&sequence)
            {
                if records.len() == records.capacity() {
                    return Err("canonical record capacity was underestimated".into());
                }
                records.push(Record {
                    signature: signature(&sequence, energy),
                    packed: pack(&indices),
                });
            }
            depth -= 1;
            continue;
        }

        let choice = usize::from(next[depth]);
        if choice == VALUES.len() {
            next[depth] = 0;
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        next[depth] += 1;
        let value = VALUES[choice];
        let sum = prefix_sum[depth] + value;
        let energy = prefix_energy[depth] + value * value;
        let remaining = LENGTH - depth - 1;
        let Some(target_slot) = sum_slot(1 - sum) else {
            continue;
        };
        let least_remaining = minimum_energy[remaining][target_slot];
        if least_remaining == i16::MAX || energy + least_remaining > TARGET_ENERGY - LENGTH as i16 {
            continue;
        }
        sequence[depth] = value;
        indices[depth] = choice as u8;
        prefix_sum[depth + 1] = sum;
        prefix_energy[depth + 1] = energy;
        depth += 1;
    }

    if complete != 17_562_843 || records.len() != RECORD_CAPACITY {
        return Err(format!(
            "enumeration census drifted: complete={complete} canonical={}",
            records.len()
        )
        .into());
    }
    records.sort_unstable_by_key(|record| record.signature);
    records.dedup_by_key(|record| record.signature);

    let mut signature_output = std::env::var("ERGODIS_LEGENDRE_SIGNATURES")
        .ok()
        .map(|path| std::fs::File::create_new(path).map(BufWriter::new))
        .transpose()?;
    let mut matching_signatures = 0_u64;
    let mut signature_pairs = 0_u64;
    let mut witness = None;
    for &record in &records {
        let complement = Signature {
            energy: TARGET_ENERGY - record.signature.energy,
            paf: record.signature.paf.map(|value| TARGET_PAF - value),
        };
        if let Ok(index) =
            records.binary_search_by_key(&complement, |candidate| candidate.signature)
        {
            matching_signatures += 1;
            witness.get_or_insert((record, records[index]));
            if record.signature <= complement {
                signature_pairs += 1;
                if let Some(output) = &mut signature_output {
                    writeln!(
                        output,
                        "{} {} {} {} {}",
                        record.signature.energy,
                        record.signature.paf[0],
                        record.signature.paf[1],
                        record.signature.paf[2],
                        record.signature.paf[3]
                    )?;
                }
            }
        }
    }
    if let Some(output) = &mut signature_output {
        output.flush()?;
    }
    if let Some((left_record, right_record)) = witness {
        let left = unpack(left_record.packed);
        let right = unpack(right_record.packed);
        let left_signature = signature(&left, left.iter().map(|value| value * value).sum());
        let right_signature = signature(&right, right.iter().map(|value| value * value).sum());
        if left.iter().sum::<i16>() != 1
            || right.iter().sum::<i16>() != 1
            || left_signature.energy + right_signature.energy != TARGET_ENERGY
            || left_signature
                .paf
                .iter()
                .zip(right_signature.paf)
                .any(|(&a, b)| a + b != TARGET_PAF)
        {
            return Err("compressed witness replay failed".into());
        }
        println!(
            "status=SAT raw={complete} canonical={} signatures={} matching_signatures={matching_signatures} signature_pairs={signature_pairs} left={left:?} right={right:?}",
            RECORD_CAPACITY,
            records.len()
        );
        return Ok(());
    }
    println!(
        "status=UNSAT raw={complete} canonical={} signatures={}",
        RECORD_CAPACITY,
        records.len()
    );
    Ok(())
}
