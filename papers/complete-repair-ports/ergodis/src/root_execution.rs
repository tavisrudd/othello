//! Domain-neutral execution of independent search roots.
//!
//! A kernel creates one worker-local workspace per participating thread.  The
//! hot root callback receives a stable ordinal and never touches the scheduler,
//! allocator, serializer, or another worker's state.

use thiserror::Error;

#[cfg(test)]
use crate::test_alloc::HotLoopAllocationGuard;

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
#[repr(transparent)]
pub struct RootOrdinal(pub u32);

const _: () = assert!(size_of::<RootOrdinal>() == 4 && align_of::<RootOrdinal>() == 4);

pub trait RootKernel: Sync {
    type Root: Sync;
    type Worker;
    type Output: Send;

    fn create_worker(&self) -> Self::Worker;
    fn evaluate(
        &self,
        worker: &mut Self::Worker,
        ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output;
}

pub fn reduce_roots<K, A, Identity, Reduce>(
    kernel: &K,
    roots: &[K::Root],
    threads: usize,
    identity: Identity,
    reduce: Reduce,
) -> Result<A, RootExecutionError>
where
    K: RootKernel<Output = A>,
    A: Send,
    Identity: Fn() -> A + Send + Sync,
    Reduce: Fn(A, A) -> A + Send + Sync,
{
    // Parallel reduction may regroup outputs.  Callers must supply an
    // associative reducer with `identity()` as its identity element.
    if threads == 0 {
        return Err(RootExecutionError::ZeroThreads);
    }
    if roots.len() > u32::MAX as usize {
        return Err(RootExecutionError::TooManyRoots(roots.len()));
    }
    if threads == 1 {
        let mut worker = kernel.create_worker();
        let mut aggregate = identity();
        for (ordinal, root) in roots.iter().enumerate() {
            let output = {
                #[cfg(test)]
                let _allocation_guard = HotLoopAllocationGuard::enter();
                kernel.evaluate(&mut worker, RootOrdinal(ordinal as u32), root)
            };
            aggregate = reduce(aggregate, output);
        }
        return Ok(aggregate);
    }
    #[cfg(feature = "parallel")]
    {
        use rayon::prelude::*;
        let pool = rayon::ThreadPoolBuilder::new()
            .num_threads(threads)
            .build()
            .map_err(|error| RootExecutionError::ThreadPool(error.to_string()))?;
        Ok(pool.install(|| {
            roots
                .par_iter()
                .enumerate()
                .map_init(
                    || kernel.create_worker(),
                    |worker, (ordinal, root)| {
                        #[cfg(test)]
                        let _allocation_guard = HotLoopAllocationGuard::enter();
                        kernel.evaluate(worker, RootOrdinal(ordinal as u32), root)
                    },
                )
                .reduce(identity, reduce)
        }))
    }
    #[cfg(not(feature = "parallel"))]
    Err(RootExecutionError::ParallelFeatureRequired)
}

#[derive(Debug, Error)]
pub enum RootExecutionError {
    #[error("thread count must be positive")]
    ZeroThreads,
    #[error("root count {0} exceeds the stable u32 ordinal space")]
    TooManyRoots(usize),
    #[cfg(feature = "parallel")]
    #[error("cannot create root worker pool: {0}")]
    ThreadPool(String),
    #[cfg(not(feature = "parallel"))]
    #[error("thread counts above one require the parallel feature")]
    ParallelFeatureRequired,
}

#[cfg(test)]
mod tests {
    use super::*;

    struct SumKernel;

    impl RootKernel for SumKernel {
        type Root = u32;
        type Worker = u64;
        type Output = u64;

        fn create_worker(&self) -> Self::Worker {
            0
        }

        fn evaluate(
            &self,
            worker: &mut Self::Worker,
            ordinal: RootOrdinal,
            root: &Self::Root,
        ) -> Self::Output {
            *worker += 1;
            u64::from(*root) + u64::from(ordinal.0)
        }
    }

    #[test]
    fn stable_ordinals_survive_parallel_regrouping() {
        let roots = [10, 20, 30, 40, 50];
        let serial = reduce_roots(&SumKernel, &roots, 1, || 0, |a, b| a + b).unwrap();
        assert_eq!(serial, 160);
        #[cfg(feature = "parallel")]
        assert_eq!(
            reduce_roots(&SumKernel, &roots, 4, || 0, |a, b| a + b).unwrap(),
            serial
        );
    }

    #[cfg(feature = "parallel")]
    #[test]
    fn serial_and_parallel_root_callbacks_allocate_nothing() {
        let roots = [10, 20, 30, 40, 50];
        let ((serial, parallel), events) = crate::test_alloc::measure_allocations(|| {
            let serial = reduce_roots(&SumKernel, &roots, 1, || 0, |a, b| a + b).unwrap();
            let parallel = reduce_roots(&SumKernel, &roots, 3, || 0, |a, b| a + b).unwrap();
            (serial, parallel)
        });
        assert_eq!(serial, parallel);
        assert_eq!(events, Default::default());
    }
}
