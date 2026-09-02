use anyhow::Result;
use clap::Parser;
use ergodis_private::z2k_subgroup::subgroup_membership_z2k;

#[derive(Debug, Parser)]
struct Args {
    #[arg(long, default_value_t = 20_000_000)]
    iterations: u64,
}

fn unpack_mod16(value: u32) -> [u16; 8] {
    std::array::from_fn(|coordinate| ((value >> (4 * coordinate)) & 15) as u16)
}

fn main() -> Result<()> {
    let args = Args::parse();
    let packed = [
        128_u32,
        2_112,
        3_072,
        16_384,
        78_128,
        209_928,
        1_118_832,
        1_136_480,
        18_948_648,
        33_751_632,
        268_505_448,
    ];
    let generators: [[u16; 8]; 11] = packed.map(unpack_mod16);
    let mut random = 0xd8c7_b6a5_9483_7261_u64;
    let mut checksum = 0_u64;
    for _ in 0..args.iterations {
        random ^= random << 13;
        random ^= random >> 7;
        random ^= random << 17;
        let membership = subgroup_membership_z2k(&generators, unpack_mod16(random as u32), 4)?;
        checksum = checksum.wrapping_add(u64::from(membership.contains));
        std::hint::black_box(membership);
    }
    println!("iterations={} checksum={checksum}", args.iterations);
    Ok(())
}
