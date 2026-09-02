use ergodis_private::order6_crt_residual::{
    Order6LiftDirectory, Order6MarginKey, EISENSTEIN_ENERGY_TARGET, ORDER6_COLUMNS,
    ORDER6_DIRECTORY_LEN,
};

fn convolve_u128(left: &[u128], right: &[u128], output: &mut [u128]) -> bool {
    output.fill(0);
    let mut support_energy = [0_u16; 109];
    let mut support_count = [0_u128; 109];
    let mut support_len = 0_usize;
    for (energy, &count) in right.iter().take(109).enumerate() {
        if count != 0 {
            support_energy[support_len] = energy as u16;
            support_count[support_len] = count;
            support_len += 1;
        }
    }
    for (first, &first_count) in left.iter().enumerate() {
        if first_count == 0 {
            continue;
        }
        for slot in 0..support_len {
            let second = usize::from(support_energy[slot]);
            if first + second >= output.len() {
                break;
            }
            let second_count = support_count[slot];
            let Some(product) = first_count.checked_mul(second_count) else {
                return false;
            };
            let Some(sum) = output[first + second].checked_add(product) else {
                return false;
            };
            output[first + second] = sum;
        }
    }
    true
}

fn main() {
    let directory = Order6LiftDirectory::compile().unwrap();
    let mut coefficientwise_max = [0_u128; EISENSTEIN_ENERGY_TARGET + 1];
    let mut feasible = 0_u32;
    let mut mean_polynomial = [0_f64; EISENSTEIN_ENERGY_TARGET + 1];
    let mut best_repeated = 0_u128;
    let mut best_key = 0_u16;
    let mut mean_bivariate = [[0_f64; 7]; EISENSTEIN_ENERGY_TARGET + 1];
    for raw_key in 0..ORDER6_DIRECTORY_LEN {
        let lifts = directory.lifts(Order6MarginKey(raw_key as u16)).unwrap();
        if lifts.is_empty() {
            continue;
        }
        feasible += 1;
        let mut polynomial = [0_u128; EISENSTEIN_ENERGY_TARGET + 1];
        for lift in lifts {
            polynomial[usize::from(lift.residual().norm())] += 1;
            mean_bivariate[usize::from(lift.residual().norm())]
                [usize::from(lift.extreme_count())] += 1.0;
        }
        for energy in 0..=EISENSTEIN_ENERGY_TARGET {
            coefficientwise_max[energy] = coefficientwise_max[energy].max(polynomial[energy]);
            mean_polynomial[energy] += polynomial[energy] as f64;
        }
        let mut current = [0_u128; EISENSTEIN_ENERGY_TARGET + 1];
        let mut next = [0_u128; EISENSTEIN_ENERGY_TARGET + 1];
        current[0] = 1;
        for _ in 0..ORDER6_COLUMNS {
            assert!(convolve_u128(&current, &polynomial, &mut next));
            std::mem::swap(&mut current, &mut next);
        }
        let count = current.iter().sum::<u128>();
        if count > best_repeated {
            best_repeated = count;
            best_key = raw_key as u16;
        }
    }
    for coefficient in &mut mean_polynomial {
        *coefficient /= f64::from(feasible);
    }
    let mut bivariate_support = Vec::new();
    for energy in 0..=EISENSTEIN_ENERGY_TARGET {
        for extremes in 0..=6 {
            let coefficient = mean_bivariate[energy][extremes] / f64::from(feasible);
            if coefficient != 0.0 {
                bivariate_support.push((energy, extremes, coefficient));
            }
        }
    }
    let coefficientwise_max_f64 = coefficientwise_max.map(|value| value as f64);
    let mut upper_current = [0_f64; EISENSTEIN_ENERGY_TARGET + 1];
    let mut upper_next = [0_f64; EISENSTEIN_ENERGY_TARGET + 1];
    upper_current[0] = 1.0;
    for _ in 0..ORDER6_COLUMNS {
        upper_next.fill(0.0);
        for first in 0..=EISENSTEIN_ENERGY_TARGET {
            for second in 0..=EISENSTEIN_ENERGY_TARGET - first {
                upper_next[first + second] +=
                    upper_current[first] * coefficientwise_max_f64[second];
            }
        }
        std::mem::swap(&mut upper_current, &mut upper_next);
    }
    let upper = upper_current.iter().sum::<f64>();

    let mut mean_current = [0_f64; EISENSTEIN_ENERGY_TARGET + 1];
    let mut mean_next = [0_f64; EISENSTEIN_ENERGY_TARGET + 1];
    mean_current[0] = 1.0;
    for _ in 0..ORDER6_COLUMNS {
        mean_next.fill(0.0);
        for first in 0..=EISENSTEIN_ENERGY_TARGET {
            for second in 0..=EISENSTEIN_ENERGY_TARGET - first {
                mean_next[first + second] += mean_current[first] * mean_polynomial[second];
            }
        }
        std::mem::swap(&mut mean_current, &mut mean_next);
    }
    let mean = mean_current.iter().sum::<f64>();
    const EXTREME_TARGET: usize = 173;
    let stride = EXTREME_TARGET + 1;
    let mut joint_current = vec![0_f64; (EISENSTEIN_ENERGY_TARGET + 1) * stride];
    let mut joint_next = vec![0_f64; joint_current.len()];
    joint_current[0] = 1.0;
    for _ in 0..ORDER6_COLUMNS * 4 {
        joint_next.fill(0.0);
        for energy in 0..=EISENSTEIN_ENERGY_TARGET {
            for extremes in 0..=EXTREME_TARGET {
                let count = joint_current[energy * stride + extremes];
                if count == 0.0 {
                    continue;
                }
                for &(added_energy, added_extremes, multiplicity) in &bivariate_support {
                    if energy + added_energy <= EISENSTEIN_ENERGY_TARGET
                        && extremes + added_extremes <= EXTREME_TARGET
                    {
                        joint_next[(energy + added_energy) * stride + extremes + added_extremes] +=
                            count * multiplicity;
                    }
                }
            }
        }
        std::mem::swap(&mut joint_current, &mut joint_next);
    }
    let joint = joint_current[EISENSTEIN_ENERGY_TARGET * stride + EXTREME_TARGET];
    println!(
        "feasible_keys={feasible} repeated_key={} repeated_words={} repeated_bits={:.6} coefficientwise_upper={:.6e} upper_bits={:.6} uniform_expected={:.6e} uniform_bits={:.6} quartet_energy_extreme_expected={:.6e} quartet_energy_extreme_bits={:.6}",
        best_key,
        best_repeated,
        (best_repeated as f64).log2(),
        upper,
        upper.log2(),
        mean,
        mean.log2(),
        joint,
        joint.log2()
    );
}
