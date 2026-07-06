// Grundy / nimber solver for the sum-free achievement game via disjunctive-sum
// component decomposition.
//
// The game is a disjunctive game: at any position A the residual game splits
// over the connected components of the armed Schur interaction hypergraph on the
// legal moves U, and Grundy(A) = XOR over components of Grundy(component).  This
// is a proven identity (2026-07-04-sumfree-game-theorem, "verified 0 mismatches
// / ~70k positions") and, unlike the queens analogue, it FIRES: a probe on
// Z3^2 x Z7 shows 84% of nodes split into >=2 components (82-99% in the deep
// tail, mean 5-6 tiny components).  So the engine memoizes *components* (keyed
// by the canonical form of the armed hypergraph under Aut(G)) rather than whole
// positions, which collapses the P-proof tree that has no boolean cutoff.
//
// Correctness gate (Codex's exact Grundy table + the mod-6 cyclic law):
//   Z2=1 Z3=1 Z5=0 Z7=0 Z9=1 Z10=1 Z14=2  Z2xZ3=0  Z3^2=1
//   Z3xZ5=2 Z3xZ7=1 Z3xZ11=1 Z3xZ13=1  Z3^2xZ5=2   and Z3^2xZ7 => 0 (P)
//   cyclic Z_n: Grundy 0 iff n = 0,1,5 mod 6.
//
// Build: go build -o grundy ./cmd_grundy/grundy.go
// Run:   ./grundy 3,3,7
package main

import (
	"fmt"
	"math/bits"
	"os"
	"runtime"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"time"
)

// ---------- 256-bit mask ----------

const W = 4

type Mask [W]uint64

func (m *Mask) setBit(i int)   { m[i>>6] |= 1 << uint(i&63) }
func (m *Mask) clearBit(i int) { m[i>>6] &^= 1 << uint(i&63) }
func (m Mask) has(i int) bool  { return m[i>>6]>>uint(i&63)&1 == 1 }
func (m Mask) or(o Mask) Mask {
	for i := 0; i < W; i++ {
		m[i] |= o[i]
	}
	return m
}
func (m Mask) and(o Mask) Mask {
	for i := 0; i < W; i++ {
		m[i] &= o[i]
	}
	return m
}
func (m Mask) andNot(o Mask) Mask {
	for i := 0; i < W; i++ {
		m[i] &^= o[i]
	}
	return m
}
func (m Mask) isZero() bool {
	return m[0] == 0 && m[1] == 0 && m[2] == 0 && m[3] == 0
}
func (m Mask) popcount() int {
	c := 0
	for i := 0; i < W; i++ {
		c += bits.OnesCount64(m[i])
	}
	return c
}
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
		base := w << 6
		for x != 0 {
			b := bits.TrailingZeros64(x)
			f(base | b)
			x &= x - 1
		}
	}
}

// ---------- group (copied from ../sumfree.go; stable machinery) ----------

type Group struct {
	mods   []int
	N      int
	elems  [][]int
	idx    map[string]int
	add    [][]int
	neg    []int
	dblpre []Mask
	full   Mask
	auto   [][]uint16
}

func keyOf(e []int) string {
	sb := make([]byte, 0, len(e)*3)
	for _, c := range e {
		sb = append(sb, byte('0'+c/100), byte('0'+(c/10)%10), byte('0'+c%10))
	}
	return string(sb)
}

func gcd(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

func newGroup(mods []int) *Group {
	g := &Group{mods: mods}
	N := 1
	for _, m := range mods {
		N *= m
	}
	if N > 256 {
		fmt.Fprintf(os.Stderr, "|G|=%d exceeds 256-bit mask\n", N)
		os.Exit(2)
	}
	g.N = N
	g.elems = make([][]int, N)
	g.idx = make(map[string]int, N)
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
		g.dblpre[g.add[x][x]].setBit(x)
	}
	for i := 0; i < N; i++ {
		g.full.setBit(i)
	}
	g.buildAut()
	return g
}

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
	var f3 []int
	for c, m := range mods {
		if m == 3 {
			f3 = append(f3, c)
		}
	}
	if len(f3) >= 1 {
		for _, ci := range f3 {
			for _, cj := range f3 {
				if ci == cj {
					continue
				}
				ii, jj := ci, cj
				gens = append(gens, permFromCoordMap(func(e []int) []int {
					out := append([]int(nil), e...)
					out[ii] = (e[ii] + e[jj]) % 3
					return out
				}))
			}
		}
		c0 := f3[0]
		gens = append(gens, permFromCoordMap(func(e []int) []int {
			out := append([]int(nil), e...)
			out[c0] = (e[c0] * 2) % 3
			return out
		}))
	}
	// Multiplier maps x_c -> u*x_c for every unit u.  These are the Aut(Z_m)
	// factors; for a large coprime modulus p they inflate |Aut| by (p-1), which
	// dominates armedKey's per-node cost.  GRUNDY_NOMULT drops the multipliers on
	// moduli > 3 (SOUND: canonicalizing under a subgroup only merges fewer states,
	// never inequivalent ones) to trade memo size for per-node speed.
	noMult := os.Getenv("GRUNDY_NOMULT") != ""
	for c, m := range mods {
		if noMult && m > 3 {
			continue
		}
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
	compose := func(p, q []uint16) []uint16 {
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
	var sd, t Mask
	for i := 0; i < n; i++ {
		x := bitsA[i]
		t = t.or(g.dblpre[x])
		rowP := g.add[x]
		for j := 0; j < n; j++ {
			y := bitsA[j]
			s := rowP[y]
			sd[s>>6] |= 1 << uint(s&63)
			d := g.add[x][g.neg[y]]
			sd[d>>6] |= 1 << uint(d&63)
		}
	}
	forbidden := a.or(sd).or(t)
	forbidden.setBit(0)
	return g.full.andNot(forbidden)
}

// ---------- component decomposition ----------

// linked reports whether legal moves x,y lie in a common live Schur triple
// (third element in A|U): x+y, x-y, or y-x in au.
func (g *Group) linked(x, y int, au Mask) bool {
	if au.has(g.add[x][y]) {
		return true
	}
	if au.has(g.add[x][g.neg[y]]) {
		return true
	}
	return au.has(g.add[y][g.neg[x]])
}

// components returns the connected components of U (as masks) under the armed
// interaction rule.  Returns a single-element slice [U] when U is connected.
func (g *Group) components(a, u Mask) []Mask {
	var idx [256]int
	n := 0
	u.forEach(func(x int) { idx[n] = x; n++ })
	au := a.or(u)
	parent := make([]int, n)
	for i := range parent {
		parent[i] = i
	}
	var find func(int) int
	find = func(i int) int {
		for parent[i] != i {
			parent[i] = parent[parent[i]]
			i = parent[i]
		}
		return i
	}
	for i := 0; i < n; i++ {
		for j := i + 1; j < n; j++ {
			if g.linked(idx[i], idx[j], au) {
				ri, rj := find(i), find(j)
				if ri != rj {
					parent[ri] = rj
				}
			}
		}
	}
	rootMask := map[int]Mask{}
	for i := 0; i < n; i++ {
		r := find(i)
		m := rootMask[r]
		m.setBit(idx[i])
		rootMask[r] = m
	}
	out := make([]Mask, 0, len(rootMask))
	for _, m := range rootMask {
		out = append(out, m)
	}
	return out
}

// ---------- Grundy solver ----------

// The memo key is a 128-bit FINGERPRINT of the canonical armed component
// (U, A_rel).  Storing the fingerprint in a flat preallocated open-addressing
// table — rather than the two 64-byte Masks in a Go map — cuts the per-entry
// footprint ~4x (17 packed bytes vs a 64-byte key plus Go-map bucket/overflow
// and 2x growth-transient) and removes the entries from GC scanning, letting
// larger p fit in RAM.  Sound with overwhelming probability: over 1e8 entries
// the 128-bit collision probability is ~2^-70 (the fingerprint-TT argument the
// queens solver uses).  Validated exact-equivalent to the map engine on the
// 50+ gate values.

func fingerprint(u, a Mask) (uint64, uint64) {
	h0 := u[0]*0x9E3779B97F4A7C15 ^ u[1]*0xC2B2AE3D27D4EB4F ^ u[2]*0x165667B19E3779F9 ^ u[3]*0xD6E8FEB86659FD93
	h0 ^= a[0]*0xFF51AFD7ED558CCD ^ a[1]*0xC4CEB9FE1A85EC53 ^ a[2]*0x2545F4914F6CDD1D ^ a[3]*0x9E3779B185EBCA87
	h0 ^= h0 >> 30
	h0 *= 0xBF58476D1CE4E5B9
	h0 ^= h0 >> 27
	h0 *= 0x94D049BB133111EB
	h0 ^= h0 >> 31
	h1 := u[0]*0xD1B54A32D192ED03 ^ u[1]*0xAEF17502108EF2D9 ^ u[2]*0xA0761D6478BD642F ^ u[3]*0xE7037ED1A0B428DB
	h1 ^= a[0]*0x8EBC6AF09C88C6E3 ^ a[1]*0x589965CC75374CC3 ^ a[2]*0x1D8E4E27C47D124F ^ a[3]*0xEB44ACCAB455D165
	h1 ^= h1 >> 30
	h1 *= 0xBF58476D1CE4E5B9
	h1 ^= h1 >> 27
	h1 *= 0x94D049BB133111EB
	h1 ^= h1 >> 31
	return h0, h1
}

const nShards = 512

// memoShard is a linear-probing open-addressing table on the 128-bit
// fingerprint (k0,k1) -> nimber value.  val == -1 marks an empty slot (nimbers
// are 0..127).  Sized to a power of two; grows (doubles + rehashes) past 0.7
// load.  k0,k1,val are parallel slices so there is no per-slot struct padding.
type memoShard struct {
	mu   sync.Mutex
	k0   []uint64
	k1   []uint64
	val  []int8
	used int
	mask uint64 // len-1 (len is a power of two)
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

type gsolver struct {
	g      *Group
	shard  [nShards]memoShard
	nodes  int64
	sem    chan struct{}
	parPly int
	t0     time.Time
}

// probe start uses bits above the low 9 (which select the shard) to decorrelate.
func (s *gsolver) memoGet(f0, f1 uint64) (int8, bool) {
	sh := &s.shard[f0&(nShards-1)]
	sh.mu.Lock()
	i := (f0 >> 9) & sh.mask
	for {
		v := sh.val[i]
		if v == -1 {
			sh.mu.Unlock()
			return 0, false
		}
		if sh.k0[i] == f0 && sh.k1[i] == f1 {
			sh.mu.Unlock()
			return v, true
		}
		i = (i + 1) & sh.mask
	}
}

func (s *gsolver) memoPut(f0, f1 uint64, v int8) {
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

func (s *gsolver) memoSize() int {
	n := 0
	for i := range s.shard {
		s.shard[i].mu.Lock()
		n += s.shard[i].used
		s.shard[i].mu.Unlock()
	}
	return n
}

// applyPerm maps every set bit of m through permutation p.
func applyPerm(m Mask, p []uint16) Mask {
	var t Mask
	for w := 0; w < W; w++ {
		x := m[w]
		base := w << 6
		for x != 0 {
			b := bits.TrailingZeros64(x)
			d := int(p[base+b])
			t[d>>6] |= 1 << uint(d&63)
			x &= x - 1
		}
	}
	return t
}

// armedKey canonicalizes the pair (U, A_rel) jointly under Aut(G).  A_rel is the
// arming of the hypergraph: the A-elements that are a sum/difference of two
// U-members (the only part of A that affects the subgame on U).  Two subgames
// with the same armedKey have Aut-isomorphic armed hypergraphs => equal Grundy.
func (s *gsolver) armedKey(a, u Mask) (uint64, uint64) {
	g := s.g
	// arel = A ∩ { x+y, x-y : x,y in U }
	var arel Mask
	var idx [256]int
	n := 0
	u.forEach(func(x int) { idx[n] = x; n++ })
	for i := 0; i < n; i++ {
		x := idx[i]
		for j := i; j < n; j++ {
			y := idx[j]
			if sm := g.add[x][y]; a.has(sm) {
				arel.setBit(sm)
			}
			if d1 := g.add[x][g.neg[y]]; a.has(d1) {
				arel.setBit(d1)
			}
			if d2 := g.add[y][g.neg[x]]; a.has(d2) {
				arel.setBit(d2)
			}
		}
	}
	bestU, bestA := u, arel
	for _, p := range g.auto {
		pu := applyPerm(u, p)
		if pu.less(bestU) {
			bestU = pu
			bestA = applyPerm(arel, p)
		} else if pu == bestU {
			pa := applyPerm(arel, p)
			if pa.less(bestA) {
				bestA = pa
			}
		}
	}
	return fingerprint(bestU, bestA)
}

func mex(seen map[int]bool) int {
	for i := 0; ; i++ {
		if !seen[i] {
			return i
		}
	}
}

// sub returns the Grundy value of the subgame from placed set A with moves
// restricted to component C.
// forkChildren evaluates the given tasks, running each in a worker goroutine
// when a semaphore slot is free and inline otherwise (the standard bounded-pool
// recursion pattern — never blocks on a full pool, so it cannot deadlock).
// Grundy has no cutoff, so every task must run; results are order-independent.
func (s *gsolver) forkChildren(n int, run func(i int) int) []int {
	results := make([]int, n)
	var wg sync.WaitGroup
	for i := 0; i < n; i++ {
		select {
		case s.sem <- struct{}{}:
			wg.Add(1)
			go func(i int) {
				defer wg.Done()
				defer func() { <-s.sem }()
				results[i] = run(i)
			}(i)
		default:
			results[i] = run(i)
		}
	}
	wg.Wait()
	return results
}

func (s *gsolver) sub(a, c Mask) int {
	u := c.and(s.g.legalMask(a))
	pc := u.popcount()
	if pc == 0 {
		return 0
	}
	// A single isolated legal move is a *1 Nim-heap (play it, subgame ends).
	if pc == 1 {
		return 1
	}
	comps := s.g.components(a, u)
	depth := a.popcount()
	if len(comps) >= 2 {
		if depth < s.parPly {
			res := s.forkChildren(len(comps), func(i int) int { return s.sub(a, comps[i]) })
			x := 0
			for _, r := range res {
				x ^= r
			}
			return x
		}
		x := 0
		for _, ci := range comps {
			x ^= s.sub(a, ci)
		}
		return x
	}
	// single connected component
	// pc==2 connected ⇒ one conflict edge (the two moves cannot coexist) ⇒
	// either move ends the subgame ⇒ Grundy = mex{0,0} = 1.  Skip canonicalization.
	if pc == 2 {
		return 1
	}
	f0, f1 := s.armedKey(a, u)
	if v, ok := s.memoGet(f0, f1); ok {
		return int(v)
	}
	atomic.AddInt64(&s.nodes, 1)
	seen := map[int]bool{}
	if depth < s.parPly {
		var moves []int
		u.forEach(func(mv int) { moves = append(moves, mv) })
		res := s.forkChildren(len(moves), func(i int) int {
			child := a
			child.setBit(moves[i])
			rest := u
			rest.clearBit(moves[i])
			return s.sub(child, rest)
		})
		for _, r := range res {
			seen[r] = true
		}
	} else {
		u.forEach(func(mv int) {
			child := a
			child.setBit(mv)
			rest := u
			rest.clearBit(mv)
			seen[s.sub(child, rest)] = true
		})
	}
	v := mex(seen)
	if v > 127 {
		fmt.Fprintf(os.Stderr, "grundy value %d exceeds int8\n", v)
		os.Exit(1)
	}
	s.memoPut(f0, f1, int8(v))
	return v
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
		fmt.Fprintln(os.Stderr, "usage: grundy <mods>   e.g. grundy 3,3,7   [--start c0,c1,..;..]")
		os.Exit(2)
	}
	mods := parseMods(os.Args[1])
	startCoords := ""
	j := runtime.NumCPU() - 2
	if j < 1 {
		j = 1
	}
	parPly := 10
	for i := 2; i < len(os.Args); i++ {
		switch os.Args[i] {
		case "--start":
			if i+1 < len(os.Args) {
				startCoords = os.Args[i+1]
				i++
			}
		case "-j":
			if i+1 < len(os.Args) {
				j, _ = strconv.Atoi(os.Args[i+1])
				i++
			}
		case "--par-ply":
			if i+1 < len(os.Args) {
				parPly, _ = strconv.Atoi(os.Args[i+1])
				i++
			}
		}
	}
	t0 := time.Now()
	g := newGroup(mods)
	name := make([]string, len(mods))
	for i, m := range mods {
		name[i] = "Z" + strconv.Itoa(m)
	}
	fmt.Printf("[%s] |G|=%d |Aut|=%d  j=%d par-ply=%d\n", strings.Join(name, "x"), g.N, len(g.auto), j, parPly)

	s := &gsolver{g: g, sem: make(chan struct{}, j), parPly: parPly, t0: t0}
	for i := range s.shard {
		s.shard[i].init(256)
	}

	// progress ticker
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
					time.Since(t0).Seconds(), atomic.LoadInt64(&s.nodes), s.memoSize(), rssMB())
			}
		}
	}()

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
	gval := s.sub(start, g.full)
	close(done)
	outcome := "P"
	if gval != 0 {
		outcome = "N"
	}
	fmt.Printf("  GRUNDY=%d  OUTCOME=%s  nodes=%d  memo=%d  time=%.2fs  rss=%dMB\n",
		gval, outcome, atomic.LoadInt64(&s.nodes), s.memoSize(), time.Since(t0).Seconds(), rssMB())
}
