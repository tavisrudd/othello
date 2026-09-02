use anyhow::{anyhow, ensure, Result};
use clap::Parser;
use ergodis_private::g41_q29_exact_tablebase::compile_g41_q29_aggregate_block_tablebase;
use ergodis_private::g41_q29_profile_shard::{
    compile_g41_q29_projection_index, join_g41_q29_profile_shard, G41Q29ProfileShardWorkspace,
};

#[derive(Parser)]
struct Args {
    #[arg(long, default_value_t = 5)]
    middle_small: u8,
    #[arg(long, value_delimiter = ',', num_args = 4)]
    indices: Vec<u32>,
    #[arg(long, value_delimiter = ',', num_args = 2)]
    left_projection_sum: Vec<u16>,
    #[arg(long, default_value_t = 0)]
    first_coordinate: usize,
    #[arg(long, default_value_t = 1)]
    second_coordinate: usize,
    #[arg(long, default_value_t = 16_777_216)]
    capacity: usize,
    #[arg(long, default_value_t = 1)]
    repeat: u32,
}

fn run<const FIRST: usize, const SECOND: usize>(args: &Args) -> Result<()> {
    let middle_signature = match args.middle_small {
        1 => [1, 9, 14, 14],
        5 => [5, 8, 14, 14],
        _ => anyhow::bail!("middle-small must select profile class 1 or 5"),
    };
    let a = compile_g41_q29_aggregate_block_tablebase([8, 3, 15, 15])?;
    let b = compile_g41_q29_aggregate_block_tablebase(middle_signature)?;
    let c = compile_g41_q29_aggregate_block_tablebase([9, 7, 14, 14])?;
    let sets = [
        &a.profiles[..],
        &b.profiles[..],
        &c.profiles[..],
        &b.profiles[..],
    ];
    let left_projection_sum = if args.left_projection_sum.is_empty() {
        let raw_indices: [u32; 4] =
            args.indices.clone().try_into().map_err(|_| {
                anyhow!("provide four profile indices or an explicit projection sum")
            })?;
        ensure!((0..4).all(|block| (raw_indices[block] as usize) < sets[block].len()));
        [
            a.profiles[raw_indices[0] as usize].coordinate(FIRST)
                + c.profiles[raw_indices[2] as usize].coordinate(FIRST),
            a.profiles[raw_indices[0] as usize].coordinate(SECOND)
                + c.profiles[raw_indices[2] as usize].coordinate(SECOND),
        ]
    } else {
        ensure!(
            args.indices.is_empty(),
            "choose indices or a projection sum"
        );
        args.left_projection_sum
            .clone()
            .try_into()
            .map_err(|_| anyhow!("projection sum requires exactly two values"))?
    };
    let ia = compile_g41_q29_projection_index::<FIRST, SECOND>(&a.profiles)?;
    let ib = compile_g41_q29_projection_index::<FIRST, SECOND>(&b.profiles)?;
    let ic = compile_g41_q29_projection_index::<FIRST, SECOND>(&c.profiles)?;
    let mut workspace = G41Q29ProfileShardWorkspace::new(args.capacity)?;
    ensure!(args.repeat != 0);
    let mut report = None;
    for _ in 0..args.repeat {
        report = Some(join_g41_q29_profile_shard::<FIRST, SECOND>(
            sets,
            [&ia, &ib, &ic, &ib],
            left_projection_sum,
            &mut workspace,
        )?);
    }
    serde_json::to_writer(std::io::stdout(), &report)?;
    println!();
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    ensure!(args.indices.len() == 4 || args.left_projection_sum.len() == 2);
    match (args.first_coordinate, args.second_coordinate) {
        (0, 1) => run::<0, 1>(&args),
        (0, 2) => run::<0, 2>(&args),
        (0, 3) => run::<0, 3>(&args),
        _ => anyhow::bail!("supported coordinate representatives are 0,1; 0,2; and 0,3"),
    }
}
