use anyhow::Result;
use clap::{Parser, ValueEnum};
use ergodis_private::two_adic_autocorrelation::synthesize_binary_orbit_autocorrelation_form;

#[derive(Clone, Copy, Debug, ValueEnum)]
enum Operation {
    Synthesize,
    Replay,
}

#[derive(Debug, Parser)]
struct Args {
    #[arg(long, value_enum)]
    operation: Operation,
    #[arg(long, default_value_t = 1_000_000)]
    iterations: u64,
}

fn q29_semantics() -> ([u8; 29], [u16; 7]) {
    const COSETS: [[usize; 4]; 7] = [
        [1, 12, 28, 17],
        [2, 24, 27, 5],
        [3, 7, 26, 22],
        [4, 19, 25, 10],
        [6, 14, 23, 15],
        [8, 9, 21, 20],
        [11, 16, 18, 13],
    ];
    let mut classes = [0_u8; 29];
    let mut shifts = [0_u16; 7];
    for (class, coset) in COSETS.iter().enumerate() {
        shifts[class] = coset[0] as u16;
        for &point in coset {
            classes[point] = (class + 1) as u8;
        }
    }
    (classes, shifts)
}

fn main() -> Result<()> {
    let args = Args::parse();
    let (classes, shifts) = q29_semantics();
    let weights = [1_u8; 7];
    let form =
        synthesize_binary_orbit_autocorrelation_form::<29, 8, 7>(&classes, &shifts, &weights)?;
    let mut checksum = 0_u64;
    match args.operation {
        Operation::Synthesize => {
            for _ in 0..args.iterations {
                let derived = synthesize_binary_orbit_autocorrelation_form::<29, 8, 7>(
                    &classes, &shifts, &weights,
                )?;
                checksum ^= derived.diagonal;
                std::hint::black_box(derived);
            }
        }
        Operation::Replay => {
            let mut input = 0xd8c7_b6a5_9483_7261_u64;
            for _ in 0..args.iterations {
                input ^= input << 13;
                input ^= input >> 7;
                input ^= input << 17;
                checksum += u64::from(form.evaluate(input & 255));
            }
        }
    }
    println!("iterations={} checksum={checksum}", args.iterations);
    Ok(())
}
