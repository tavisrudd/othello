//! Exhaustive minimum-distance kernel enumerator used by the adjacent checker.
use std::io::{self, Read};
use std::thread;

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let basis: Vec<(u64, u64)> = input
        .lines()
        .filter(|line| !line.is_empty())
        .map(|line| {
            let mut fields = line.split_whitespace();
            (
                u64::from_str_radix(fields.next().unwrap(), 16).unwrap(),
                u64::from_str_radix(fields.next().unwrap(), 16).unwrap(),
            )
        })
        .collect();
    assert!(basis.len() <= 32);
    let total = 1u64 << basis.len();
    let workers = thread::available_parallelism().unwrap().get().min(total as usize);
    let mut handles = Vec::new();
    for worker in 0..workers {
        let local_basis = basis.clone();
        handles.push(thread::spawn(move || {
            let start = total * worker as u64 / workers as u64;
            let end = total * (worker + 1) as u64 / workers as u64;
            let mut gray = start ^ (start >> 1);
            let (mut low, mut high) = (0u64, 0u64);
            let mut bits = gray;
            while bits != 0 {
                let index = bits.trailing_zeros() as usize;
                low ^= local_basis[index].0;
                high ^= local_basis[index].1;
                bits &= bits - 1;
            }
            let (mut minimum, mut count) = (92u32, 0u64);
            for coefficient in start..end {
                if coefficient != 0 {
                    let weight = low.count_ones() + high.count_ones();
                    if weight < minimum {
                        minimum = weight;
                        count = 1;
                    } else if weight == minimum {
                        count += 1;
                    }
                }
                if coefficient + 1 < end {
                    let next = (coefficient + 1) ^ ((coefficient + 1) >> 1);
                    let index = (gray ^ next).trailing_zeros() as usize;
                    low ^= local_basis[index].0;
                    high ^= local_basis[index].1;
                    gray = next;
                }
            }
            (minimum, count)
        }));
    }
    let mut minimum = 92u32;
    let mut count = 0u64;
    for handle in handles {
        let (local_minimum, local_count) = handle.join().unwrap();
        if local_minimum < minimum {
            minimum = local_minimum;
            count = local_count;
        } else if local_minimum == minimum {
            count += local_count;
        }
    }
    println!("{} {} {}", minimum, count, total);
}
