// Fast, small solver for the impartial SUM-FREE achievement game on a finite
// abelian group G = Z_{m1} x ... x Z_{mk}.
//
//	Position A = a sum-free subset of G (no a+b=c with a,b,c in A, a=b allowed).
//	Move       = add x, x!=0, x not in A, keeping A u {x} sum-free.  Normal play.
//	Outcome    = N (player to move wins) / P (player to move loses).
//
// Speed: negamax + transposition table keyed by the canonical form of A under
// the full automorphism group Aut(G).  For G = Z3^a x (coprime cyclic part)
// Aut(G) = GL(a,3) x (product of unit groups), generated below and closed by
// BFS.  Canonicalization is SOUND (genuine automorphisms only) and here also
// COMPLETE (full Aut) for maximal reduction.
//
// Build: go build -o sumfree ./sumfree.go   (light compile, ~200MB)
// Run:   ./sumfree 3,3,7                 # outcome + one winning move
//
//	./sumfree 3,3,7 --openings      # list all winning first moves
//	./sumfree 3,3,7 --start 0,1,0   # outcome with A preset to these coords
package main

import (
	"fmt"
	"math/bits"
	"os"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"time"
)

// ---------- 256-bit mask (supports |G| up to 256) ----------

const W = 4

type Mask [W]uint64

func (m *Mask) setBit(i int)  { m[i>>6] |= 1 << uint(i&63) }
func (m Mask) has(i int) bool { return m[i>>6]>>uint(i&63)&1 == 1 }
func (m Mask) or(o Mask) Mask {
	for i := 0; i < W; i++ {
		m[i] |= o[i]
	}
	return m
}
func (m Mask) andNot(o Mask) Mask {
	for i := 0; i < W; i++ {
		m[i] &^= o[i]
	}
	return m
}
func (m Mask) popcount() int {
	c := 0
	for i := 0; i < W; i++ {
		c += bits.OnesCount64(m[i])
	}
	return c
}

// lexicographic order (word 0 most significant is arbitrary but consistent)
func (m Mask) less(o Mask) bool {
	for i := W - 1; i >= 0; i-- {
		if m[i] != o[i] {
			return m[i] < o[i]
		}
	}
	return false
}

func (m Mask) forEach(f func(int)) {
	for w := 0; w < W; w++ {
		x := m[w]
		for x != 0 {
			b := bits.TrailingZeros64(x)
			f(w<<6 | b)
			x &= x - 1
		}
	}
}

// ---------- group ----------

type Group struct {
	mods   []int
	N      int
	elems  [][]int
	idx    map[string]int
	add    [][]int // add[a][b] = index of (a+b)
	neg    []int
	dblpre []Mask // dblpre[e] = {x : 2x = e}
	full   Mask   // all indices 0..N-1
	auto   [][]uint16
}

func keyOf(e []int) string {
	sb := make([]byte, 0, len(e)*3)
	for _, c := range e {
		sb = append(sb, byte('0'+c/100), byte('0'+(c/10)%10), byte('0'+c%10))
	}
	return string(sb)
}

func newGroup(mods []int) *Group {
	g := &Group{mods: mods}
	N := 1
	for _, m := range mods {
		N *= m
	}
	g.N = N
	g.elems = make([][]int, N)
	g.idx = make(map[string]int, N)
	// mixed-radix enumeration (last coord fastest)
	for i := 0; i < N; i++ {
		e := make([]int, len(mods))
		r := i
		for c := len(mods) - 1; c >= 0; c-- {
			e[c] = r % mods[c]
			r /= mods[c]
		}
		g.elems[i] = e
		g.idx[keyOf(e)] = i
	}
	addv := func(a, b []int) int {
		e := make([]int, len(mods))
		for c := range mods {
			e[c] = (a[c] + b[c]) % mods[c]
		}
		return g.idx[keyOf(e)]
	}
	g.add = make([][]int, N)
	for a := 0; a < N; a++ {
		row := make([]int, N)
		for b := 0; b < N; b++ {
			row[b] = addv(g.elems[a], g.elems[b])
		}
		g.add[a] = row
	}
	g.neg = make([]int, N)
	for e := 0; e < N; e++ {
		ne := make([]int, len(mods))
		for c := range mods {
			ne[c] = (mods[c] - g.elems[e][c]) % mods[c]
		}
		g.neg[e] = g.idx[keyOf(ne)]
	}
	g.dblpre = make([]Mask, N)
	for x := 0; x < N; x++ {
		d := g.add[x][x]
		g.dblpre[d].setBit(x)
	}
	for i := 0; i < N; i++ {
		g.full.setBit(i)
	}
	g.buildAut()
	return g
}

// gcd
func gcd(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

// buildAut generates the automorphism group as a list of permutations of
// element indices, closed under composition.  Generators:
//   - GL(k,3) transvections + a scaling, over the coordinates with modulus 3;
//   - multiplier maps x_c -> u*x_c for every unit u of Z_{mods[c]} (all factors);
//   - coordinate swaps between factors of equal modulus.
//
// All are genuine automorphisms; closure yields the full Aut(G) for the
// direct products we use (coprime F3-block x cyclic units).
func (g *Group) buildAut() {
	N := g.N
	mods := g.mods
	var gens [][]uint16

	permFromCoordMap := func(f func(e []int) []int) []uint16 {
		p := make([]uint16, N)
		for i := 0; i < N; i++ {
			p[i] = uint16(g.idx[keyOf(f(g.elems[i]))])
		}
		return p
	}

	// F3 block: GL(k,3) on the mod-3 coordinates.
	var f3 []int
	for c, m := range mods {
		if m == 3 {
			f3 = append(f3, c)
		}
	}
	if len(f3) >= 1 {
		// transvections: coord i += coord j (mod 3), i!=j
		for _, ci := range f3 {
			for _, cj := range f3 {
				if ci == cj {
					continue
				}
				gens = append(gens, permFromCoordMap(func(e []int) []int {
					out := append([]int(nil), e...)
					out[ci] = (e[ci] + e[cj]) % 3
					return out
				}))
			}
		}
		// scaling on the first f3 coord by 2 (= -1), gives determinant flip
		c0 := f3[0]
		gens = append(gens, permFromCoordMap(func(e []int) []int {
			out := append([]int(nil), e...)
			out[c0] = (e[c0] * 2) % 3
			return out
		}))
	}

	// Multiplier maps for every coordinate: x_c -> u*x_c for each unit u.
	for c, m := range mods {
		for u := 2; u < m; u++ {
			if gcd(u, m) != 1 {
				continue
			}
			cc, uu, mm := c, u, m
			gens = append(gens, permFromCoordMap(func(e []int) []int {
				out := append([]int(nil), e...)
				out[cc] = (e[cc] * uu) % mm
				return out
			}))
		}
	}

	// Coordinate swaps between equal-modulus factors.
	for a := 0; a < len(mods); a++ {
		for b := a + 1; b < len(mods); b++ {
			if mods[a] == mods[b] {
				aa, bb := a, b
				gens = append(gens, permFromCoordMap(func(e []int) []int {
					out := append([]int(nil), e...)
					out[aa], out[bb] = e[bb], e[aa]
					return out
				}))
			}
		}
	}

	// BFS closure.
	ident := make([]uint16, N)
	for i := range ident {
		ident[i] = uint16(i)
	}
	permKey := func(p []uint16) string {
		b := make([]byte, 2*len(p))
		for i, v := range p {
			b[2*i] = byte(v)
			b[2*i+1] = byte(v >> 8)
		}
		return string(b)
	}
	compose := func(p, q []uint16) []uint16 { // (p after q)[i] = p[q[i]]
		r := make([]uint16, N)
		for i := 0; i < N; i++ {
			r[i] = p[q[i]]
		}
		return r
	}
	seen := map[string]bool{permKey(ident): true}
	group := [][]uint16{ident}
	for i := 0; i < len(group); i++ {
		for _, gg := range gens {
			np := compose(gg, group[i])
			k := permKey(np)
			if !seen[k] {
				seen[k] = true
				group = append(group, np)
			}
		}
	}
	g.auto = group
}

// canon returns the lexicographically minimal image of a under Aut(G).
// Hot path: inlined bit iteration, no closures/allocations.
func (g *Group) canon(a Mask) Mask {
	best := a
	for _, p := range g.auto {
		var t Mask
		for w := 0; w < W; w++ {
			x := a[w]
			base := w << 6
			for x != 0 {
				b := bits.TrailingZeros64(x)
				d := int(p[base+b])
				t[d>>6] |= 1 << uint(d&63)
				x &= x - 1
			}
		}
		if t.less(best) {
			best = t
		}
	}
	return best
}

// legalMask returns the set of legal moves from sum-free position a.
// Hot path: inlined bit iteration collecting A's members, then S/D/T sweep.
func (g *Group) legalMask(a Mask) Mask {
	var bitsA [256]int
	n := 0
	for w := 0; w < W; w++ {
		x := a[w]
		base := w << 6
		for x != 0 {
			b := bits.TrailingZeros64(x)
			bitsA[n] = base | b
			n++
			x &= x - 1
		}
	}
	var sd, t Mask // sd = S(A) u D(A), t = T(A)
	for i := 0; i < n; i++ {
		x := bitsA[i]
		t = t.or(g.dblpre[x])
		rowP := g.add[x] // x + y
		for j := 0; j < n; j++ {
			y := bitsA[j]
			s := rowP[y] // x + y
			sd[s>>6] |= 1 << uint(s&63)
			d := g.add[x][g.neg[y]] // x - y
			sd[d>>6] |= 1 << uint(d&63)
		}
	}
	forbidden := a.or(sd).or(t)
	forbidden.setBit(0) // 0 is never legal
	return g.full.andNot(forbidden)
}

// ---------- transposition table: preallocated fingerprint arena ----------
//
// The TT is a preallocated open-addressing arena keyed by a 128-bit FINGERPRINT
// of the canonical position canon(A), storing one int8 per slot (0 = player to
// move loses / P, 1 = wins / N; -1 = empty).  This replaces a map[Mask]bool,
// whose 32-byte key + Go-map bucket/overflow/2x-growth overhead and full GC
// scanning ballooned past 10 GB and OOM'd at |G|=135 (Z3^3 x Z5).  The arena is
// ~17 packed bytes/entry (three parallel slices, no per-slot padding),
// GC-invisible, and preallocated, so large groups fit in RAM.  Sound with
// overwhelming probability: at 1e8 entries the 128-bit collision probability is
// ~2^-70 -- the same fingerprint-TT argument the grundy engine and the queens
// solver use.  Node exploration is unchanged from the map version; only the memo
// storage is different.

func fingerprint(a Mask) (uint64, uint64) {
	h0 := a[0]*0x9E3779B97F4A7C15 ^ a[1]*0xC2B2AE3D27D4EB4F ^ a[2]*0x165667B19E3779F9 ^ a[3]*0xD6E8FEB86659FD93
	h0 ^= h0 >> 30
	h0 *= 0xBF58476D1CE4E5B9
	h0 ^= h0 >> 27
	h0 *= 0x94D049BB133111EB
	h0 ^= h0 >> 31
	h1 := a[0]*0xD1B54A32D192ED03 ^ a[1]*0xAEF17502108EF2D9 ^ a[2]*0xA0761D6478BD642F ^ a[3]*0xE7037ED1A0B428DB
	h1 ^= h1 >> 30
	h1 *= 0xBF58476D1CE4E5B9
	h1 ^= h1 >> 27
	h1 *= 0x94D049BB133111EB
	h1 ^= h1 >> 31
	return h0, h1
}

// Two TT arenas, both sharded (nShards independent tables, each behind its own
// mutex) so the parallel search's concurrent get/put on different fingerprints
// rarely contend.  Uncontended lock/unlock (~20 ns) is negligible against the
// per-node canon over all |Aut| permutations that dominates the search.
//
//   - DEFAULT (memoShard): an EXACT growing memo.  Linear-probing open addressing
//     on the 128-bit fingerprint (k0,k1) -> {0,1}; val==-1 marks empty; k0,k1,val
//     are parallel slices (no per-slot padding).  Doubles + rehashes past 0.7
//     load, never evicts.  Bounded only by RAM; the validated default.
//   - FIXED (fixedShard, opt-in via SUMFREE_TT_GB / SUMFREE_TT_SLOTS): a bounded
//     evicting cache, sized once and never grown, so it CANNOT OOM.  See its note.

const nShards = 512

// ways = entries per cache-line bucket in the fixed arena.  ways*8 bytes == 64 ==
// one cache line, so a probe of a bucket is a single memory access.
const ways = 8

const _ = "tiger: ways*8 must equal a 64-byte cache line" // ways*8 == 64 by construction

type memoShard struct {
	mu   sync.Mutex
	k0   []uint64
	k1   []uint64
	val  []int8
	used int
	mask uint64
}

func (sh *memoShard) init(n int) {
	sh.k0 = make([]uint64, n)
	sh.k1 = make([]uint64, n)
	sh.val = make([]int8, n)
	for i := range sh.val {
		sh.val[i] = -1
	}
	sh.mask = uint64(n - 1)
}

// grow doubles the shard and rehashes (caller holds sh.mu).
func (sh *memoShard) grow() {
	ok0, ok1, oval := sh.k0, sh.k1, sh.val
	n := int(sh.mask+1) * 2
	sh.k0 = make([]uint64, n)
	sh.k1 = make([]uint64, n)
	sh.val = make([]int8, n)
	for i := range sh.val {
		sh.val[i] = -1
	}
	sh.mask = uint64(n - 1)
	sh.used = 0
	for j := range oval {
		if oval[j] != -1 {
			i := (ok0[j] >> 9) & sh.mask
			for sh.val[i] != -1 {
				i = (i + 1) & sh.mask
			}
			sh.k0[i], sh.k1[i], sh.val[i] = ok0[j], ok1[j], oval[j]
			sh.used++
		}
	}
}

// fixedShard is the FIXED-RAM evicting arena (Tiger-style tight representation).
// One shard is a flat []uint64 of `nBuckets*ways` slots; bucket b owns the
// contiguous run slot[b*ways : b*ways+ways] == one 64-byte cache line.  Each slot
// packs an entry into a single u64:
//
//	bits 63..7 : sig   (57-bit fingerprint signature, the high bits of f1)
//	bits  6..2 : cost  (5-bit log2 subtree-node-count class, the eviction key)
//	bits  1..0 : tag   (0 = empty, 1 = loss/P, 2 = win/N)
//
// 8 bytes/entry vs the default arena's 21 (u64+u64+i8), so a given RAM budget
// holds ~2.6x more of the working set -> eviction bites far later.  The key is
// (shard bits + bucket index from f0) + (57-bit sig from f1) ~= 90+ effective
// bits, so a false match is ~2^-50 at 1e9 entries (the fingerprint-TT argument).
// It NEVER grows: on a full bucket it evicts the lowest cost-class way (keeping
// the expensive-to-recompute deep subtrees, discarding cheap near-leaf ones), so
// RAM is fixed and it cannot OOM.  Eviction is correctness-preserving -- an
// evicted position is simply recomputed -- so only speed (re-expansion) is traded.
type fixedShard struct {
	mu    sync.Mutex
	slot  []uint64
	bmask uint64 // nBuckets-1 (nBuckets is a power of two)
	used  int
}

func (fs *fixedShard) init(nBuckets int) {
	fs.slot = make([]uint64, nBuckets*ways) // zeroed => every slot tag==0 (empty)
	fs.bmask = uint64(nBuckets - 1)
}

const fixedSigMask = (uint64(1) << 57) - 1

// ---------- solver ----------

type Solver struct {
	g         *Group
	shard     [nShards]memoShard  // default exact growing arena
	fshard    [nShards]fixedShard // fixed evicting arena (used iff fixed)
	fixed     bool
	totalUsed int64 // atomic: live TT entries (progress)
	nodes     int64 // atomic
	order     bool
	sem       chan struct{} // bounded worker pool for the parallel fork
	parPly    int           // fork younger brothers only above this ply (0 = fully sequential)
}

// memoGet returns (value, subtree-size estimate, hit).  The estimate is the
// recompute cost carried for the fixed arena's eviction accounting (0 for the
// default arena, which never evicts).  Probe start uses bits above the low 9
// (which pick the shard) to decorrelate from shard selection.
func (s *Solver) memoGet(f0, f1 uint64) (int8, uint32, bool) {
	if s.fixed {
		fs := &s.fshard[f0&(nShards-1)]
		fs.mu.Lock()
		base := int((f0>>9)&fs.bmask) * ways
		sig := (f1 >> 7) & fixedSigMask
		for w := 0; w < ways; w++ {
			slot := fs.slot[base+w]
			if slot&3 != 0 && slot>>7 == sig {
				tag := int8(slot & 3)
				est := uint32(1) << ((slot >> 2) & 31)
				fs.mu.Unlock()
				return tag - 1, est, true // tag 1->0 (loss/P), 2->1 (win/N)
			}
		}
		fs.mu.Unlock()
		return 0, 0, false
	}
	sh := &s.shard[f0&(nShards-1)]
	sh.mu.Lock()
	i := (f0 >> 9) & sh.mask
	for {
		v := sh.val[i]
		if v == -1 {
			sh.mu.Unlock()
			return 0, 0, false
		}
		if sh.k0[i] == f0 && sh.k1[i] == f1 {
			sh.mu.Unlock()
			return v, 0, true
		}
		i = (i + 1) & sh.mask
	}
}

// memoPut stores (value, subtree cost).  cost drives the fixed arena's eviction
// (larger subtree class survives); the default arena ignores it.
func (s *Solver) memoPut(f0, f1 uint64, v int8, cost uint32) {
	if s.fixed {
		fs := &s.fshard[f0&(nShards-1)]
		fs.mu.Lock()
		base := int((f0>>9)&fs.bmask) * ways
		sig := (f1 >> 7) & fixedSigMask
		tag := uint64(v) + 1 // 0 (loss) -> 1, 1 (win) -> 2
		cc := uint64(bits.Len32(cost))
		if cc > 31 {
			cc = 31
		}
		emptyW, minW := -1, 0
		minCC := uint64(32)
		for w := 0; w < ways; w++ {
			slot := fs.slot[base+w]
			if slot&3 == 0 {
				if emptyW < 0 {
					emptyW = w
				}
				continue
			}
			if slot>>7 == sig { // update in place; keep the larger cost class
				if ec := (slot >> 2) & 31; ec > cc {
					cc = ec
				}
				fs.slot[base+w] = sig<<7 | cc<<2 | tag
				fs.mu.Unlock()
				return
			}
			if c := (slot >> 2) & 31; c < minCC {
				minCC = c
				minW = w
			}
		}
		if emptyW >= 0 {
			fs.slot[base+emptyW] = sig<<7 | cc<<2 | tag
			fs.used++
			atomic.AddInt64(&s.totalUsed, 1)
			fs.mu.Unlock()
			return
		}
		if cc >= minCC { // full bucket: evict the cheapest way for a >=-value newcomer
			fs.slot[base+minW] = sig<<7 | cc<<2 | tag
		}
		fs.mu.Unlock()
		return
	}
	sh := &s.shard[f0&(nShards-1)]
	sh.mu.Lock()
	if uint64(sh.used+1)*10 >= (sh.mask+1)*7 { // load factor 0.7
		sh.grow()
	}
	i := (f0 >> 9) & sh.mask
	for {
		if sh.val[i] == -1 {
			sh.k0[i], sh.k1[i], sh.val[i] = f0, f1, v
			sh.used++
			atomic.AddInt64(&s.totalUsed, 1)
			sh.mu.Unlock()
			return
		}
		if sh.k0[i] == f0 && sh.k1[i] == f1 {
			sh.val[i] = v
			sh.mu.Unlock()
			return
		}
		i = (i + 1) & sh.mask
	}
}

// childMask returns a with move mv added (a is a value copy, so the caller's
// mask is untouched).
func childMask(a Mask, mv int) Mask {
	a[mv>>6] |= 1 << uint(mv&63)
	return a
}

// moveOrder fills out[:n] with the legal moves in try order and returns n.  With
// s.order it is most-forcing-first: the key is the number of opponent replies
// the move leaves (popcount of the child's legal mask), sorted ascending -- a
// move leaving the opponent few (or zero) replies is the likeliest loss for them
// (an alpha-beta cutoff), so trying it first refutes N-positions with fewer
// nodes.  The extra per-node legalMask sweep is cheap next to canon (which runs
// over all |Aut| permutations).  Without s.order it is plain bit order.  No
// closures (avoids the per-node heap alloc forEach would incur on this hot path).
func (s *Solver) moveOrder(a, legal Mask, out []int) int {
	n := 0
	if !s.order {
		for w := 0; w < W; w++ {
			x := legal[w]
			base := w << 6
			for x != 0 {
				b := bits.TrailingZeros64(x)
				x &= x - 1
				out[n] = base | b
				n++
			}
		}
		return n
	}
	var keys [256]int
	for w := 0; w < W; w++ {
		x := legal[w]
		base := w << 6
		for x != 0 {
			b := bits.TrailingZeros64(x)
			x &= x - 1
			mv := base | b
			out[n] = mv
			keys[n] = s.g.legalMask(childMask(a, mv)).popcount()
			n++
		}
	}
	// insertion sort ascending by reply count (n is small)
	for i := 1; i < n; i++ {
		k, mv := keys[i], out[i]
		j := i - 1
		for j >= 0 && keys[j] > k {
			keys[j+1], out[j+1] = keys[j], out[j]
			j--
		}
		keys[j+1], out[j+1] = k, mv
	}
	return n
}

func addSat(a, b uint32) uint32 {
	if s := uint64(a) + uint64(b); s <= 0xFFFFFFFF {
		return uint32(s)
	}
	return 0xFFFFFFFF
}

// win returns (player-to-move wins?, subtree node count).  The node count is the
// recompute cost stored with the entry so the fixed arena can prefer keeping
// expensive (deep) subtrees over cheap near-leaf ones when it evicts.
func (s *Solver) win(a Mask) (bool, uint32) {
	f0, f1 := fingerprint(s.g.canon(a))
	if v, est, ok := s.memoGet(f0, f1); ok {
		return v == 1, est
	}
	atomic.AddInt64(&s.nodes, 1)
	legal := s.g.legalMask(a)
	var mvs [256]int
	n := s.moveOrder(a, legal, mvs[:])

	res := false
	cost := uint32(1)
	depth := a.popcount()
	if s.parPly > 0 && depth < s.parPly && n > 1 {
		// YBWC: the eldest son is tried SEQUENTIALLY -- with move ordering it is
		// the likeliest alpha-beta cutoff, so if it refutes the node we spent no
		// speculative work.  Only when it does NOT cut off (this is then most
		// likely a prove-a-loss / P-node, whose children must all be checked --
		// there is no cutoff left to lose) do we fork the younger brothers.
		w0, c0 := s.win(childMask(a, mvs[0]))
		cost = addSat(cost, c0)
		if !w0 {
			res = true
		} else {
			r, c := s.forkRest(a, mvs[1:n])
			cost = addSat(cost, c)
			res = r
		}
	} else {
		// Sequential with the alpha-beta cutoff (also the deterministic -j1 path).
		for i := 0; i < n; i++ {
			w, c := s.win(childMask(a, mvs[i]))
			cost = addSat(cost, c)
			if !w {
				res = true
				break
			}
		}
	}

	v := int8(0)
	if res {
		v = 1
	}
	s.memoPut(f0, f1, v, cost)
	return res, cost
}

// forkRest evaluates the younger-brother moves concurrently: each runs in a
// worker goroutine when a semaphore slot is free and inline otherwise (the
// standard bounded-pool recursion -- never blocks on a full pool, so it cannot
// deadlock).  Returns (any child is a loss => this node is a win, summed subtree
// cost).  All brothers are evaluated (no cutoff between them); with good move
// ordering the cutoff, if any, was already the eldest son, so the speculative
// work here is small.
func (s *Solver) forkRest(a Mask, moves []int) (bool, uint32) {
	results := make([]bool, len(moves))
	costs := make([]uint32, len(moves))
	var wg sync.WaitGroup
	for i := range moves {
		mv := moves[i]
		select {
		case s.sem <- struct{}{}:
			wg.Add(1)
			go func(i, mv int) {
				defer wg.Done()
				defer func() { <-s.sem }()
				results[i], costs[i] = s.win(childMask(a, mv))
			}(i, mv)
		default:
			results[i], costs[i] = s.win(childMask(a, mv))
		}
	}
	wg.Wait()
	found := false
	total := uint32(0)
	for i := range results {
		total = addSat(total, costs[i])
		if !results[i] { // a child is a loss => this position is a win (N)
			found = true
		}
	}
	return found, total
}

func (s *Solver) winningOpenings(start Mask) []int {
	legal := s.g.legalMask(start)
	var wins []int
	legal.forEach(func(x int) {
		child := start
		child.setBit(x)
		if w, _ := s.win(child); !w {
			wins = append(wins, x)
		}
	})
	sort.Ints(wins)
	return wins
}

// ---------- CLI ----------

func parseMods(s string) []int {
	var out []int
	for _, p := range strings.Split(s, ",") {
		v, err := strconv.Atoi(strings.TrimSpace(p))
		if err != nil || v <= 1 {
			fmt.Fprintf(os.Stderr, "bad modulus %q\n", p)
			os.Exit(2)
		}
		out = append(out, v)
	}
	return out
}

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: sumfree <mods> [--openings] [--start c0,c1,..;..] [-j N|-j 0=all] [--par-ply P]\n"+
			"  env: SUMFREE_TT_GB=N or SUMFREE_TT_SLOTS=N => fixed evicting arena (bounded RAM); SUMFREE_ORDER=0 => no move ordering")
		os.Exit(2)
	}
	mods := parseMods(os.Args[1])
	openings := false
	startCoords := ""
	// Default SERIAL: the search is transposition-bound, so parallel DFS re-expands
	// shared transpositions (measured 2-3.4x node inflation) -- a bounded, sublinear,
	// nondeterministic win (~2-4x, only because the per-node canon is heavy CPU).
	// The deterministic levers (arena + move ordering) are the real speedups.
	// `-j N` opts into N workers; `-j 0` uses all cores (NumCPU-2).
	j := 1
	// Fork horizon when parallel: fork only the top `par-ply` plies (the wide,
	// low-sharing part of the tree), keeping the deep narrow tail sequential where
	// transposition reuse is highest.  Deep games (large max sum-free set) need a
	// deeper horizon than shallow ones to expose parallel width and balance load.
	parPly := 8
	for i := 2; i < len(os.Args); i++ {
		a := os.Args[i]
		switch {
		case a == "--openings":
			openings = true
		case a == "--start":
			if i+1 < len(os.Args) {
				startCoords = os.Args[i+1]
				i++
			}
		case strings.HasPrefix(a, "--start="):
			startCoords = a[len("--start="):]
		case a == "-j":
			if i+1 < len(os.Args) {
				j, _ = strconv.Atoi(os.Args[i+1])
				i++
			}
		case a == "--par-ply":
			if i+1 < len(os.Args) {
				parPly, _ = strconv.Atoi(os.Args[i+1])
				i++
			}
		}
	}
	if j == 0 { // -j 0 => use all cores
		j = runtime.NumCPU() - 2
	}
	if j < 1 {
		j = 1
	}
	if j == 1 {
		parPly = 0 // fully sequential => deterministic node count (validation path)
	}

	t0 := time.Now()
	g := newGroup(mods)
	var start Mask
	if startCoords != "" {
		for _, tok := range strings.Split(startCoords, ";") {
			var e []int
			for _, c := range strings.Split(tok, ",") {
				v, _ := strconv.Atoi(strings.TrimSpace(c))
				e = append(e, v)
			}
			start.setBit(g.idx[keyOf(e)])
		}
	}
	// TT config, resolved once (never in the hot loop).  Default = the exact GROWING
	// arena (bounded only by RAM).  If SUMFREE_TT_GB (RAM budget, GiB) or
	// SUMFREE_TT_SLOTS (total slots) is set, use the FIXED tight evicting arena
	// instead: bounded RAM, cannot OOM (see fixedShard).  8 bytes per packed slot.
	order := os.Getenv("SUMFREE_ORDER") != "0" // default on
	s := &Solver{g: g, order: order, sem: make(chan struct{}, j), parPly: parPly}
	totalSlots := envInt("SUMFREE_TT_SLOTS", 0)
	if gb := envInt("SUMFREE_TT_GB", 0); gb > 0 && totalSlots == 0 {
		totalSlots = gb * (1 << 30) / 8
	}
	ttDesc := "growing (exact)"
	if totalSlots > 0 {
		s.fixed = true
		pb := 1
		for pb*2*nShards*ways <= totalSlots {
			pb <<= 1 // largest power-of-two buckets/shard within the budget
		}
		for i := range s.fshard {
			s.fshard[i].init(pb)
		}
		slots := pb * nShards * ways
		ttDesc = fmt.Sprintf("fixed %.1fGiB (%d slots, evicting)", float64(slots)*8/(1<<30), slots)
	} else {
		initSlots := 1
		for initSlots < envInt("SUMFREE_TT_INIT", 256) {
			initSlots <<= 1 // power of two (open-addressing mask requires it)
		}
		for i := range s.shard {
			s.shard[i].init(initSlots)
		}
	}

	name := make([]string, len(mods))
	for i, m := range mods {
		name[i] = "Z" + strconv.Itoa(m)
	}
	fmt.Printf("[%s] |G|=%d |Aut|=%d  order=%v j=%d par-ply=%d tt=%s\n",
		strings.Join(name, "x"), g.N, len(g.auto), order, j, parPly, ttDesc)

	// Progress ticker (stderr): for the large groups these runs can take many
	// minutes; report nodes and RSS so the run is followable and memory is watched.
	done := make(chan struct{})
	go func() {
		tk := time.NewTicker(15 * time.Second)
		defer tk.Stop()
		for {
			select {
			case <-done:
				return
			case <-tk.C:
				fmt.Fprintf(os.Stderr, "  [%4.0fs] nodes=%d memo=%d rss=%dMB\n",
					time.Since(t0).Seconds(), atomic.LoadInt64(&s.nodes), atomic.LoadInt64(&s.totalUsed), rssMB())
			}
		}
	}()

	if openings {
		wins := s.winningOpenings(start)
		outcome := "P"
		if len(wins) > 0 {
			outcome = "N"
		}
		fmt.Printf("  OUTCOME=%s  winning_openings=%d\n", outcome, len(wins))
		labels := make([]string, len(wins))
		for i, x := range wins {
			labels[i] = fmt.Sprint(g.elems[x])
		}
		fmt.Printf("  moves=%s\n", strings.Join(labels, " "))
	} else {
		w, _ := s.win(start)
		outcome := "P"
		if w {
			outcome = "N"
		}
		fmt.Printf("  OUTCOME=%s (%s)\n", outcome, map[bool]string{true: "player to move wins", false: "player to move loses"}[w])
		if w {
			wins := s.winningOpenings(start)
			if len(wins) > 0 {
				fmt.Printf("  winning move=%v\n", g.elems[wins[0]])
			}
		}
	}
	close(done)
	fmt.Printf("  nodes=%d tt=%d time=%.2fs rss=%dMB\n",
		atomic.LoadInt64(&s.nodes), atomic.LoadInt64(&s.totalUsed), time.Since(t0).Seconds(), rssMB())
}

func envInt(name string, def int) int {
	if v := os.Getenv(name); v != "" {
		if n, err := strconv.Atoi(v); err == nil {
			return n
		}
	}
	return def
}

func rssMB() int {
	b, err := os.ReadFile("/proc/self/statm")
	if err != nil {
		return 0
	}
	f := strings.Fields(string(b))
	if len(f) < 2 {
		return 0
	}
	pages, _ := strconv.Atoi(f[1])
	return pages * 4096 / (1024 * 1024)
}
