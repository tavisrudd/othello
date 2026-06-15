//! Native open-addressing transposition table, port of `_search.TranspositionTable`.
//!
//! A flat array indexed by a hash of `(black, white, to_move, depth)`. Each slot
//! stores the full key, so a hash collision just misses and recomputes -- never
//! a wrong entry -- and eviction only costs speed. Deliberately small (default
//! 2^16 slots ~= 1.5 MB) so it lives in L2/L3 cache; a bigger table is slower.

/// One transposition slot. `#[repr(C, align(32))]` gives a fixed, dense 32-byte
/// layout (24 bytes of payload + 8 pad) so exactly two slots fill a 64-byte
/// cache line and no probe ever straddles a line boundary -- a probe touches one
/// cache line, never two.
#[derive(Clone, Copy, Default)]
#[repr(C, align(32))]
pub(crate) struct Entry {
    pub black: u64,
    pub white: u64,
    pub value: i32,
    pub to_move: i8,
    pub depth: i8,
    pub flag: i8,
    pub used: i8,
}

// Layout invariant: a cache line holds a whole number of slots, none straddling.
const _: () = assert!(core::mem::size_of::<Entry>() == 32);
const _: () = assert!(64 % core::mem::align_of::<Entry>() == 0);

pub struct TranspositionTable {
    slots: Vec<Entry>,
    hint: Vec<u64>, // position-keyed best-move bit (lossy ordering hint)
    mask: usize,
    plus: bool, // use the "plus" horizon eval (the strong+ engine)
    mpc: bool,  // enable Multi-ProbCut forward pruning (the strong++ engine)
}

impl TranspositionTable {
    pub fn new(bits: u32) -> Self {
        let n = 1usize << bits;
        TranspositionTable {
            slots: vec![Entry::default(); n],
            hint: vec![0u64; n],
            mask: n - 1,
            plus: false,
            mpc: false,
        }
    }

    /// Select the stronger horizon evaluation (carried here so it threads through
    /// the search for free -- the table is already a parameter everywhere). The
    /// leaf branch on it is perfectly predictable, so `strong` is unaffected.
    pub fn set_plus(&mut self, plus: bool) {
        self.plus = plus;
    }

    /// Enable Multi-ProbCut forward pruning (the `strong++` engine). Carried here
    /// for the same reason as `plus`: the search threads the table everywhere, so
    /// the per-node gate costs one predictable branch when off.
    pub fn set_mpc(&mut self, mpc: bool) {
        self.mpc = mpc;
    }

    #[inline]
    pub(crate) fn plus(&self) -> bool {
        self.plus
    }

    #[inline]
    pub(crate) fn mpc_on(&self) -> bool {
        self.mpc
    }

    pub fn clear(&mut self) {
        for e in self.slots.iter_mut() {
            *e = Entry::default();
        }
        for h in self.hint.iter_mut() {
            *h = 0;
        }
    }

    #[inline]
    pub(crate) fn index(&self, black: u64, white: u64, to_move: i32, depth: i32) -> usize {
        let mut h = black ^ white.wrapping_mul(0x9E37_79B9_7F4A_7C15);
        h ^= ((to_move as u64) << 1) ^ ((depth as u64) << 3);
        h ^= h >> 33;
        h = h.wrapping_mul(0xFF51_AFD7_ED55_8CCD);
        h ^= h >> 33;
        (h as usize) & self.mask
    }

    #[inline]
    pub(crate) fn pos_index(&self, black: u64, white: u64, to_move: i32) -> usize {
        self.index(black, white, to_move, 0)
    }

    #[inline]
    pub(crate) fn get(&self, idx: usize) -> Entry {
        // SAFETY: idx always comes from `index`/`pos_index`, masked to < len.
        unsafe { *self.slots.get_unchecked(idx) }
    }

    #[inline]
    #[allow(clippy::too_many_arguments)] // flat key + payload; packs one slot
    pub(crate) fn store(
        &mut self,
        idx: usize,
        black: u64,
        white: u64,
        to_move: i32,
        depth: i32,
        value: i32,
        flag: i32,
    ) {
        // Negative space: a value that won't round-trip through the packed slot
        // is a bug in the caller, not something to silently truncate.
        debug_assert!((0..=1).contains(&to_move));
        debug_assert!((0..=2).contains(&flag));
        debug_assert!((i8::MIN as i32..=i8::MAX as i32).contains(&depth));
        // SAFETY: idx is masked to < len by `index`.
        unsafe {
            *self.slots.get_unchecked_mut(idx) = Entry {
                black,
                white,
                value,
                to_move: to_move as i8,
                depth: depth as i8,
                flag: flag as i8,
                used: 1,
            };
        }
    }

    #[inline]
    pub(crate) fn hint_get(&self, idx: usize) -> u64 {
        unsafe { *self.hint.get_unchecked(idx) }
    }

    #[inline]
    pub(crate) fn hint_set(&mut self, idx: usize, v: u64) {
        unsafe {
            *self.hint.get_unchecked_mut(idx) = v;
        }
    }
}
