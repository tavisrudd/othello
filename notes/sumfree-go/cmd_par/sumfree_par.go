// Parallel solver for the impartial SUM-FREE achievement game on a finite
// abelian group G = Z_{m1} x ... x Z_{mk}.  Same game/semantics as
// ../sumfree.go, but with a shared SHARDED transposition table and a bounded
// worker pool that forks the shallow plies across cores.  P-proofs (the
// expensive case: no boolean cutoff, whole canonical tree explored) parallelize
// fully; N-proofs early-cancel on the first losing child.
//
// Build: go build -o sumfree_par ./cmd_par/
// Run:   ./sumfree_par 3,3,11 [-j N] [--par-ply P] [--openings] [--start ..]
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

// ---------- 256-bit mask ----------

const W = 4

type Mask [W]uint64

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
func (m *Mask) setBit(i int) { m[i>>6] |= 1 << uint(i&63) }
func (m Mask) hash() uint64 {
	h := m[0]*0x9E3779B97F4A7C15 ^ m[1]*0xC2B2AE3D27D4EB4F ^ m[2]*0x165667B19E3779F9 ^ m[3]*0xD6E8FEB86659FD93
	h ^= h >> 31
	return h * 0xBF58476D1CE4E5B9
}

// ---------- group ----------

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

// ---------- pairing (2nd-player mirror) analysis ----------

func (g *Group) order(e int) int {
	c, y := 1, e
	for y != 0 { // element index 0 is the identity (mixed radix all zeros)
		y = g.add[y][e]
		c++
	}
	return c
}

func (g *Group) socleElems() []int {
	var s []int
	for e := 1; e < g.N; e++ {
		if g.order(e) == 3 {
			s = append(s, e)
		}
	}
	return s
}

// legalHas reports whether x is a legal move from sum-free A.
func (g *Group) legalHas(a Mask, x int) bool {
	return g.legalMask(a)[x>>6]>>uint(x&63)&1 == 1
}

// verifyPairing returns true if the pairing strategy (2nd player replies pi[x])
// wins from the empty set: over pi-symmetric sum-free positions, every legal
// 1st-player move x has pi[x] legal (and != x); then 2nd always answers ==> P.
func (g *Group) verifyPairing(pi []int) bool {
	memo := make(map[Mask]bool)
	var rec func(a Mask) bool
	rec = func(a Mask) bool {
		if v, ok := memo[a]; ok {
			return v
		}
		legal := g.legalMask(a)
		ok := true
		for w := 0; w < W && ok; w++ {
			bitsw := legal[w]
			base := w << 6
			for bitsw != 0 {
				b := bits.TrailingZeros64(bitsw)
				bitsw &= bitsw - 1
				x := base | b
				r := pi[x]
				if r == x {
					ok = false
					break
				}
				child := a
				child.setBit(x)
				if !g.legalHas(child, r) {
					ok = false
					break
				}
				child.setBit(r)
				if !rec(child) {
					ok = false
					break
				}
			}
		}
		memo[a] = ok
		return ok
	}
	var empty Mask
	return rec(empty)
}

func runPairing(g *Group, name string) {
	socle := g.socleElems()
	// base pi = negation everywhere
	base := make([]int, g.N)
	for i := 0; i < g.N; i++ {
		base[i] = g.neg[i]
	}
	// enumerate fpf involutions of socle avoiding negation pairs
	var results [][]int // each is a socle pairing as map array over socle
	var rec func(remaining []int, pairing map[int]int)
	rec = func(remaining []int, pairing map[int]int) {
		if len(remaining) == 0 {
			cp := make(map[int]int, len(pairing))
			for k, v := range pairing {
				cp[k] = v
			}
			// materialize a pi array
			pi := make([]int, g.N)
			copy(pi, base)
			for k, v := range cp {
				pi[k] = v
			}
			results = append(results, pi)
			return
		}
		a := remaining[0]
		rest := remaining[1:]
		for bi, b := range rest {
			if b == g.neg[a] {
				continue
			}
			pairing[a] = b
			pairing[b] = a
			nr := make([]int, 0, len(rest)-1)
			for k, x := range rest {
				if k == bi {
					continue
				}
				nr = append(nr, x)
			}
			rec(nr, pairing)
			delete(pairing, a)
			delete(pairing, b)
		}
	}
	rec(socle, map[int]int{})

	nwork := 0
	fmt.Printf("[%s] socle=%d candidate_pairings=%d\n", name, len(socle), len(results))
	// also test pure negation (should fail for r3>=1 groups: socle self-blocks)
	if g.verifyPairing(base) {
		fmt.Printf("  pure-negation pairing VERIFIES (unexpected)\n")
	}
	for _, pi := range results {
		if g.verifyPairing(pi) {
			nwork++
			// describe the socle pairing by F3^2 coords
			seen := map[int]bool{}
			var prs []string
			for _, a := range socle {
				if seen[a] {
					continue
				}
				b := pi[a]
				seen[a] = true
				seen[b] = true
				ea, eb := g.elems[a], g.elems[b]
				prs = append(prs, fmt.Sprintf("(%d,%d)<->(%d,%d)", ea[0], ea[1], eb[0], eb[1]))
			}
			sort.Strings(prs)
			fmt.Printf("  WORKING pairing: %s\n", strings.Join(prs, "  "))
		}
	}
	fmt.Printf("  => %d/%d socle-pairings give a verified 2nd-player win  (%s)\n",
		nwork, len(results), map[bool]string{true: "P provable via pairing", false: "NO pairing works"}[nwork > 0])
}

// ---------- sharded transposition table ----------

const nShards = 512

type shardedTT struct {
	shard [nShards]struct {
		mu sync.Mutex
		m  map[Mask]bool
		_  [40]byte // pad to reduce false sharing
	}
}

func newTT() *shardedTT {
	t := &shardedTT{}
	for i := range t.shard {
		t.shard[i].m = make(map[Mask]bool)
	}
	return t
}
func (t *shardedTT) get(k Mask) (bool, bool) {
	s := &t.shard[k.hash()&(nShards-1)]
	s.mu.Lock()
	v, ok := s.m[k]
	s.mu.Unlock()
	return v, ok
}
func (t *shardedTT) put(k Mask, v bool) {
	s := &t.shard[k.hash()&(nShards-1)]
	s.mu.Lock()
	s.m[k] = v
	s.mu.Unlock()
}
func (t *shardedTT) size() int {
	n := 0
	for i := range t.shard {
		t.shard[i].mu.Lock()
		n += len(t.shard[i].m)
		t.shard[i].mu.Unlock()
	}
	return n
}

// ---------- parallel solver ----------

type Solver struct {
	g      *Group
	tt     *shardedTT
	nodes  int64
	sem    chan struct{}
	parPly int
}

func (s *Solver) movesOf(legal Mask) []int {
	out := make([]int, 0, legal.popcount())
	for w := 0; w < W; w++ {
		x := legal[w]
		base := w << 6
		for x != 0 {
			b := bits.TrailingZeros64(x)
			out = append(out, base|b)
			x &= x - 1
		}
	}
	return out
}

func (s *Solver) win(a Mask) bool {
	key := s.g.canon(a)
	if v, ok := s.tt.get(key); ok {
		return v
	}
	atomic.AddInt64(&s.nodes, 1)
	legal := s.g.legalMask(a)
	moves := s.movesOf(legal)
	res := false
	depth := a.popcount()
	if depth < s.parPly && len(moves) > 1 {
		var found int32
		var wg sync.WaitGroup
		for _, mv := range moves {
			if atomic.LoadInt32(&found) == 1 {
				break
			}
			child := a
			child.setBit(mv)
			select {
			case s.sem <- struct{}{}:
				wg.Add(1)
				go func(c Mask) {
					defer wg.Done()
					defer func() { <-s.sem }()
					if atomic.LoadInt32(&found) == 1 {
						return
					}
					if !s.win(c) {
						atomic.StoreInt32(&found, 1)
					}
				}(child)
			default:
				if !s.win(child) {
					atomic.StoreInt32(&found, 1)
				}
			}
		}
		wg.Wait()
		res = atomic.LoadInt32(&found) == 1
	} else {
		for _, mv := range moves {
			child := a
			child.setBit(mv)
			if !s.win(child) {
				res = true
				break
			}
		}
	}
	s.tt.put(key, res)
	return res
}

// elemKind classifies x by order (in Z3^2 x Z_p): socle=order3, coprime=order p,
// mixed=order 3p.
func (g *Group) elemKind(x int) string {
	switch g.order(x) {
	case 3:
		return "socle"
	default:
		// order p (coprime) has F3^2 coords zero; mixed has both nonzero
		e := g.elems[x]
		if e[0] == 0 && e[1] == 0 {
			return "coprime"
		}
		return "mixed"
	}
}

// extractStrategy: from empty (must be P), walk the 2nd-player winning strategy
// (2nd replies; 1st branches over ALL moves). Prefer the negation reply; record
// where 2nd MUST deviate (exceptions) and how. Reveals the adaptive structure.
func (s *Solver) extractStrategy(cap int) {
	g := s.g
	var empty Mask
	if s.win(empty) {
		fmt.Println("  game is N (1st wins) — no 2nd-player strategy to extract")
		return
	}
	visited := make(map[Mask]bool)
	decisions := 0
	negHits := 0
	byXkind := map[string]int{}
	negByXkind := map[string]int{}
	exNegIllegal := map[string]int{}
	exNegLosing := map[string]int{}
	exByDepth := map[int]int{}
	exByXkind := map[string]int{}
	exKindPair := map[string]int{}
	exDelta := map[string]int{} // "xkind->rkind:df3a,df3b,dk"  aggregated
	capped := false
	var exExamples []string

	var walk func(a Mask)
	walk = func(a Mask) {
		if capped || visited[a] {
			return
		}
		if len(visited) >= cap {
			capped = true
			return
		}
		visited[a] = true
		legal := g.legalMask(a)
		moves := s.movesOf(legal)
		for _, x := range moves {
			child := a
			child.setBit(x)
			// 2nd player's winning reply: r with win(child|r)==false
			negr := g.neg[x]
			chosen := -1
			// prefer negation if legal, distinct, and winning
			if negr != x && g.legalHas(child, negr) {
				c2 := child
				c2.setBit(negr)
				if !s.win(c2) {
					chosen = negr
				}
			}
			if chosen == -1 {
				cl := s.movesOf(g.legalMask(child))
				for _, r := range cl {
					if r == x {
						continue
					}
					c2 := child
					c2.setBit(r)
					if !s.win(c2) {
						chosen = r
						break
					}
				}
			}
			if chosen == -1 {
				// should not happen (child is N ⇒ has a winning reply)
				fmt.Printf("  WARN no winning reply to %v at pc=%d\n", g.elems[x], a.popcount())
				continue
			}
			decisions++
			xk := g.elemKind(x)
			byXkind[xk]++
			if chosen == g.neg[x] {
				negHits++
				negByXkind[xk]++
			} else {
				rk := g.elemKind(chosen)
				exByXkind[xk]++
				exByDepth[a.popcount()]++
				exKindPair[xk+"->"+rk]++
				if negr != x && g.legalHas(child, negr) {
					exNegLosing[xk]++
				} else {
					exNegIllegal[xk]++
				}
				ex, ec := g.elems[x], g.elems[chosen]
				df3a := (ec[0] - ex[0] + 3) % 3
				df3b := (ec[1] - ex[1] + 3) % 3
				dk := (ec[2] - ex[2] + g.mods[2]) % g.mods[2]
				exDelta[fmt.Sprintf("%s->%s dF3=(%d,%d) dk=%d", xk, rk, df3a, df3b, dk)]++
				if len(exExamples) < 8 {
					exExamples = append(exExamples, fmt.Sprintf("A(pc=%d) x=%v -> r=%v", a.popcount(), ex, ec))
				}
			}
			nxt := child
			nxt.setBit(chosen)
			walk(nxt)
		}
	}
	walk(empty)

	fmt.Printf("  strategy-tree positions=%d%s  decisions=%d  negation=%d (%.1f%%)  exceptions=%d\n",
		len(visited), map[bool]string{true: " (CAPPED)", false: ""}[capped],
		decisions, negHits, 100*float64(negHits)/float64(decisions), decisions-negHits)
	fmt.Printf("  decisions by x-kind: %v\n", byXkind)
	fmt.Printf("  negation by x-kind: %v\n", negByXkind)
	fmt.Printf("  exceptions by x-kind: %v\n", exByXkind)
	fmt.Printf("  exceptions by x-kind->reply-kind: %v\n", exKindPair)
	fmt.Printf("  exception negation status: illegal=%v legal-but-losing=%v\n", exNegIllegal, exNegLosing)
	fmt.Printf("  exceptions by depth: %v\n", exByDepth)
	fmt.Printf("  exception (x-kind->r-kind, delta) histogram:\n")
	type kv struct {
		k string
		v int
	}
	var kvs []kv
	for k, v := range exDelta {
		kvs = append(kvs, kv{k, v})
	}
	sort.Slice(kvs, func(i, j int) bool { return kvs[i].v > kvs[j].v })
	for i, e := range kvs {
		if i >= 20 {
			break
		}
		fmt.Printf("    %-34s %d\n", e.k, e.v)
	}
	fmt.Printf("  example exceptions:\n")
	for _, e := range exExamples {
		fmt.Printf("    %s\n", e)
	}
}

func (s *Solver) winningOpenings(start Mask) []int {
	legal := s.g.legalMask(start)
	moves := s.movesOf(legal)
	var wins []int
	var mu sync.Mutex
	var wg sync.WaitGroup
	for _, mv := range moves {
		child := start
		child.setBit(mv)
		x := mv
		s.sem <- struct{}{}
		wg.Add(1)
		go func(c Mask, x int) {
			defer wg.Done()
			defer func() { <-s.sem }()
			if !s.win(c) {
				mu.Lock()
				wins = append(wins, x)
				mu.Unlock()
			}
		}(child, x)
	}
	wg.Wait()
	sort.Ints(wins)
	return wins
}

// ---------- CLI ----------

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
		fmt.Fprintln(os.Stderr, "usage: sumfree_par <mods> [-j N] [--par-ply P] [--openings] [--start ..] [--strategy-cap N]")
		os.Exit(2)
	}
	mods := parseMods(os.Args[1])
	j := runtime.NumCPU() - 2
	if j < 1 {
		j = 1
	}
	parPly := 10
	openings := false
	pairing := false
	strategy := false
	strategyCap := 20_000_000
	startCoords := ""
	args := os.Args[2:]
	for i := 0; i < len(args); i++ {
		switch args[i] {
		case "-j":
			if i+1 < len(args) {
				j, _ = strconv.Atoi(args[i+1])
				i++
			}
		case "--par-ply":
			if i+1 < len(args) {
				parPly, _ = strconv.Atoi(args[i+1])
				i++
			}
		case "--openings":
			openings = true
		case "--pairing":
			pairing = true
		case "--strategy":
			strategy = true
		case "--strategy-cap":
			if i+1 < len(args) {
				strategyCap, _ = strconv.Atoi(args[i+1])
				i++
			}
		case "--start":
			if i+1 < len(args) {
				startCoords = args[i+1]
				i++
			}
		}
	}

	t0 := time.Now()
	g := newGroup(mods)

	if pairing {
		name := make([]string, len(mods))
		for i, m := range mods {
			name[i] = "Z" + strconv.Itoa(m)
		}
		runPairing(g, strings.Join(name, "x"))
		fmt.Printf("  time=%.2fs\n", time.Since(t0).Seconds())
		return
	}
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
	s := &Solver{g: g, tt: newTT(), sem: make(chan struct{}, j), parPly: parPly}

	name := make([]string, len(mods))
	for i, m := range mods {
		name[i] = "Z" + strconv.Itoa(m)
	}
	fmt.Printf("[%s] |G|=%d |Aut|=%d  j=%d par-ply=%d\n", strings.Join(name, "x"), g.N, len(g.auto), j, parPly)

	// progress logger
	done := make(chan struct{})
	go func() {
		tk := time.NewTicker(15 * time.Second)
		defer tk.Stop()
		for {
			select {
			case <-done:
				return
			case <-tk.C:
				fmt.Fprintf(os.Stderr, "  [%4.0fs] nodes=%d rss=%dMB\n",
					time.Since(t0).Seconds(), atomic.LoadInt64(&s.nodes), rssMB())
			}
		}
	}()

	if strategy {
		s.extractStrategy(strategyCap)
		close(done)
		fmt.Printf("  nodes=%d tt=%d time=%.2fs rss=%dMB\n", s.nodes, s.tt.size(), time.Since(t0).Seconds(), rssMB())
		return
	}

	if openings {
		wins := s.winningOpenings(start)
		close(done)
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
		w := s.win(start)
		close(done)
		outcome := "P"
		if w {
			outcome = "N"
		}
		fmt.Printf("  OUTCOME=%s (%s)\n", outcome,
			map[bool]string{true: "player to move wins", false: "player to move loses"}[w])
	}
	fmt.Printf("  nodes=%d tt=%d time=%.2fs rss=%dMB\n", s.nodes, s.tt.size(), time.Since(t0).Seconds(), rssMB())
}
