// Fast, small solver for the impartial SUM-FREE achievement game on a finite
// abelian group G = Z_{m1} x ... x Z_{mk}.
//
//   Position A = a sum-free subset of G (no a+b=c with a,b,c in A, a=b allowed).
//   Move       = add x, x!=0, x not in A, keeping A u {x} sum-free.  Normal play.
//   Outcome    = N (player to move wins) / P (player to move loses).
//
// Speed: negamax + transposition table keyed by the canonical form of A under
// the full automorphism group Aut(G).  For G = Z3^a x (coprime cyclic part)
// Aut(G) = GL(a,3) x (product of unit groups), generated below and closed by
// BFS.  Canonicalization is SOUND (genuine automorphisms only) and here also
// COMPLETE (full Aut) for maximal reduction.
//
// Build: go build -o sumfree ./sumfree.go   (light compile, ~200MB)
// Run:   ./sumfree 3,3,7                 # outcome + one winning move
//        ./sumfree 3,3,7 --openings      # list all winning first moves
//        ./sumfree 3,3,7 --start 0,1,0   # outcome with A preset to these coords
package main

import (
	"fmt"
	"math/bits"
	"os"
	"sort"
	"strconv"
	"strings"
	"time"
)

// ---------- 256-bit mask (supports |G| up to 256) ----------

const W = 4

type Mask [W]uint64

func (m *Mask) setBit(i int)      { m[i>>6] |= 1 << uint(i&63) }
func (m Mask) has(i int) bool     { return m[i>>6]>>uint(i&63)&1 == 1 }
func (m Mask) or(o Mask) Mask     { for i := 0; i < W; i++ { m[i] |= o[i] }; return m }
func (m Mask) andNot(o Mask) Mask { for i := 0; i < W; i++ { m[i] &^= o[i] }; return m }
func (m Mask) popcount() int      { c := 0; for i := 0; i < W; i++ { c += bits.OnesCount64(m[i]) }; return c }

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

// ---------- solver ----------

type Solver struct {
	g     *Group
	tt    map[Mask]bool
	nodes int64
}

func (s *Solver) win(a Mask) bool {
	key := s.g.canon(a)
	if v, ok := s.tt[key]; ok {
		return v
	}
	s.nodes++
	legal := s.g.legalMask(a)
	res := false
	for w := 0; w < W && !res; w++ {
		x := legal[w]
		base := w << 6
		for x != 0 {
			b := bits.TrailingZeros64(x)
			x &= x - 1
			mv := base | b
			child := a
			child[mv>>6] |= 1 << uint(mv&63)
			if !s.win(child) {
				res = true
				break
			}
		}
	}
	s.tt[key] = res
	return res
}

func (s *Solver) winningOpenings(start Mask) []int {
	legal := s.g.legalMask(start)
	var wins []int
	legal.forEach(func(x int) {
		child := start
		child.setBit(x)
		if !s.win(child) {
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
		fmt.Fprintln(os.Stderr, "usage: sumfree <mods> [--openings] [--start c0,c1,..;..]")
		os.Exit(2)
	}
	mods := parseMods(os.Args[1])
	openings := false
	startCoords := ""
	for _, a := range os.Args[2:] {
		switch {
		case a == "--openings":
			openings = true
		case strings.HasPrefix(a, "--start"):
			// support "--start=x" or "--start x"
			if i := strings.IndexByte(a, '='); i >= 0 {
				startCoords = a[i+1:]
			}
		}
	}
	// handle "--start" followed by separate arg
	for i, a := range os.Args {
		if a == "--start" && i+1 < len(os.Args) {
			startCoords = os.Args[i+1]
		}
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
	s := &Solver{g: g, tt: make(map[Mask]bool, 1<<20)}

	name := make([]string, len(mods))
	for i, m := range mods {
		name[i] = "Z" + strconv.Itoa(m)
	}
	fmt.Printf("[%s] |G|=%d |Aut|=%d\n", strings.Join(name, "x"), g.N, len(g.auto))

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
		w := s.win(start)
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
	fmt.Printf("  nodes=%d tt=%d time=%.2fs\n", s.nodes, len(s.tt), time.Since(t0).Seconds())
}
