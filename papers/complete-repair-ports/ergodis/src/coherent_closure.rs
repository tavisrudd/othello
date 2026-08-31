//! Exact coherent refinement of finite pair observations.
//!
//! Starting from an integer label on every ordered pair, the compiler closes
//! the observation under diagonal distinction, transpose, and all two-step
//! intersection counts.  Stabilization is the concrete coherent-configuration
//! closure used by common-neighbour and sparse-shadow reconstruction.

use thiserror::Error;

pub const MAX_COHERENT_ORDER: usize = 128;

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CoherentClosure {
    order: u32,
    rank: u32,
    rounds: u32,
    colors: Box<[u32]>,
    rank_history: Box<[u32]>,
}

impl CoherentClosure {
    #[must_use]
    pub fn order(&self) -> usize {
        self.order as usize
    }

    #[must_use]
    pub fn rank(&self) -> u32 {
        self.rank
    }

    #[must_use]
    pub fn rounds(&self) -> u32 {
        self.rounds
    }

    #[must_use]
    pub fn colors(&self) -> &[u32] {
        &self.colors
    }

    #[must_use]
    pub fn rank_history(&self) -> &[u32] {
        &self.rank_history
    }

    #[must_use]
    pub fn color(&self, left: usize, right: usize) -> Option<u32> {
        (left < self.order() && right < self.order())
            .then(|| self.colors[left * self.order() + right])
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum CoherentClosureError {
    #[error("coherent refinement requires order 1..=128 and a square label table")]
    Shape,
    #[error("coherent-closure certificate failed deterministic replay")]
    Certificate,
}

#[repr(C)]
struct Signature {
    color: u32,
    transpose: u32,
    pair_offset: u32,
    pair_index: u32,
}

const _: () =
    assert!(std::mem::size_of::<Signature>() == 16 && std::mem::align_of::<Signature>() == 4);

/// Compile the coarsest coherent pair coloring refining `labels`.
///
/// `labels` is row-major on ordered pairs. The compiler is a cold algebraic
/// front end; it allocates bounded work proportional to `order^3` and is not a
/// solve-loop kernel.
pub fn compile_coherent_closure(
    order: usize,
    labels: &[i64],
) -> Result<CoherentClosure, CoherentClosureError> {
    if order == 0 || order > MAX_COHERENT_ORDER || order.checked_mul(order) != Some(labels.len()) {
        return Err(CoherentClosureError::Shape);
    }
    let width = order * order;
    let mut seeds = Vec::with_capacity(width);
    for left in 0..order {
        for right in 0..order {
            seeds.push((
                (
                    left == right,
                    labels[left * order + right],
                    labels[right * order + left],
                ),
                left * order + right,
            ));
        }
    }
    seeds.sort_unstable_by(|left, right| left.0.cmp(&right.0).then_with(|| left.1.cmp(&right.1)));
    let mut colors = vec![0_u32; width];
    let mut rank = 0_u32;
    for position in 0..seeds.len() {
        if position == 0 || seeds[position].0 != seeds[position - 1].0 {
            rank += 1;
        }
        colors[seeds[position].1] = rank - 1;
    }
    let mut rank_history = vec![rank];

    loop {
        let mut signatures = Vec::with_capacity(width);
        let mut two_step_pool = Vec::with_capacity(width * order);
        for left in 0..order {
            for right in 0..order {
                let offset = two_step_pool.len();
                for middle in 0..order {
                    two_step_pool.push((
                        colors[left * order + middle],
                        colors[middle * order + right],
                    ));
                }
                two_step_pool[offset..offset + order].sort_unstable();
                signatures.push(Signature {
                    color: colors[left * order + right],
                    transpose: colors[right * order + left],
                    pair_offset: offset as u32,
                    pair_index: (left * order + right) as u32,
                });
            }
        }
        signatures.sort_unstable_by(|left, right| {
            compare_signatures(left, right, &two_step_pool, order)
                .then_with(|| left.pair_index.cmp(&right.pair_index))
        });
        let mut next = vec![0_u32; width];
        let mut next_rank = 0_u32;
        for position in 0..signatures.len() {
            if position == 0
                || compare_signatures(
                    &signatures[position],
                    &signatures[position - 1],
                    &two_step_pool,
                    order,
                ) != std::cmp::Ordering::Equal
            {
                next_rank += 1;
            }
            next[signatures[position].pair_index as usize] = next_rank - 1;
        }
        colors = next;
        rank_history.push(next_rank);
        if next_rank == rank {
            break;
        }
        rank = next_rank;
    }
    Ok(CoherentClosure {
        order: order as u32,
        rank,
        rounds: (rank_history.len() - 1) as u32,
        colors: colors.into_boxed_slice(),
        rank_history: rank_history.into_boxed_slice(),
    })
}

fn compare_signatures(
    left: &Signature,
    right: &Signature,
    pool: &[(u32, u32)],
    width: usize,
) -> std::cmp::Ordering {
    left.color
        .cmp(&right.color)
        .then_with(|| left.transpose.cmp(&right.transpose))
        .then_with(|| {
            let left_start = left.pair_offset as usize;
            let right_start = right.pair_offset as usize;
            pool[left_start..left_start + width].cmp(&pool[right_start..right_start + width])
        })
}

/// Replay the deterministic exact refinement and compare the complete output.
pub fn verify_coherent_closure(
    labels: &[i64],
    closure: &CoherentClosure,
) -> Result<(), CoherentClosureError> {
    let replay = compile_coherent_closure(closure.order(), labels)?;
    if &replay != closure {
        return Err(CoherentClosureError::Certificate);
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn undirected_labels(order: usize, edges: &[(usize, usize)]) -> Vec<i64> {
        let mut labels = vec![0; order * order];
        for &(left, right) in edges {
            labels[left * order + right] = 1;
            labels[right * order + left] = 1;
        }
        labels
    }

    #[test]
    fn complete_graph_has_rank_two() {
        let labels = undirected_labels(
            5,
            &[
                (0, 1),
                (0, 2),
                (0, 3),
                (0, 4),
                (1, 2),
                (1, 3),
                (1, 4),
                (2, 3),
                (2, 4),
                (3, 4),
            ],
        );
        let closure = compile_coherent_closure(5, &labels).unwrap();
        assert_eq!(closure.rank(), 2);
        verify_coherent_closure(&labels, &closure).unwrap();
    }

    #[test]
    fn four_cycle_is_the_rank_three_cycle_scheme() {
        let labels = undirected_labels(4, &[(0, 1), (1, 2), (2, 3), (3, 0)]);
        let closure = compile_coherent_closure(4, &labels).unwrap();
        assert_eq!(closure.rank(), 3);
        assert_eq!(closure.color(0, 2), closure.color(1, 3));
    }

    #[test]
    fn path_refines_vertex_and_pair_types() {
        let labels = undirected_labels(3, &[(0, 1), (1, 2)]);
        let closure = compile_coherent_closure(3, &labels).unwrap();
        assert!(closure.rank() > 3);
        let mut tampered = closure.clone();
        tampered.colors[0] ^= 1;
        assert_eq!(
            verify_coherent_closure(&labels, &tampered),
            Err(CoherentClosureError::Certificate)
        );
    }

    #[test]
    fn spectral_and_coherent_routes_agree_on_five_cycle_rank() {
        let labels = undirected_labels(5, &[(0, 1), (1, 2), (2, 3), (3, 4), (4, 0)]);
        let closure = compile_coherent_closure(5, &labels).unwrap();
        let powers = crate::certify_integer_matrix_powers(5, &labels, 3, 101).unwrap();
        assert_eq!(closure.rank(), powers.power_count());
        crate::verify_integer_matrix_powers(&labels, &powers).unwrap();
    }
}
