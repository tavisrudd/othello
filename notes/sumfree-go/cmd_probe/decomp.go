// Decomposition-frequency probe for the sum-free achievement game.
//
// The game is a *disjunctive game*: at any position the residual game splits
// over the connected components of the "armed Schur interaction graph" on the
// legal moves U, and the Grundy value is the XOR of the component Grundy values
// (proven, 0 mismatches / ~70k positions -- see 2026-07-04-sumfree-game-theorem).
// A component-decomposition (Grundy-XOR) engine only pays off if positions in
// the *deep tail* actually split into >=2 components often; otherwise (like the
// queens component-nimber lever) it never fires.
//
// This standalone tool solves a fully-solvable case with a boolean negamax and
// tallies, at every explored node, the number of connected components of U,
// bucketed by depth (popcount of A).  Self-contained (copies the group
// machinery from ../sumfree.go) so it never touches the shared solver files.
//
// Build: go build -o probe ./cmd_probe/
// Run:   ./probe 3,3,7            # decomposition histogram for Z3^2 x Z7
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

// ---------- 256-bit mask ----------

const W = 4

type Mask [W]uint64

func (m *Mask) setBit(i int)  { m[i>>6] |= 1 << uint(i&63) }
func (m Mask) or(o Mask) Mask { for i := 0; i < W; i++ { m[i] |= o[i] }; return m }
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
func (m Mask) less(o Mask) bool {
	for i := W - 1; i >= 0; i-- {
		if m[i] != o[i] {
			return m[i] < o[i]
		}
	}
	return false
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

// ---------- component analysis ----------

// numComponents returns the number of connected components (and largest size)
// of the armed Schur interaction graph on the legal moves U.  Two legal moves
// x,y are linked iff a Schur triple relates them with its third element live
// (in A or U): x+y, x-y, or y-x lies in A|U.  A triple whose third element is
// neither playable nor placed imposes no future constraint (no edge).
func (g *Group) numComponents(a, legal Mask) (numComp, maxComp int) {
	var u [256]int
	n := 0
	for w := 0; w < W; w++ {
		x := legal[w]
		base := w << 6
		for x != 0 {
			b := bits.TrailingZeros64(x)
			u[n] = base | b
			n++
			x &= x - 1
		}
	}
	if n == 0 {
		return 0, 0
	}
	au := a.or(legal)
	inAU := func(z int) bool { return au[z>>6]>>uint(z&63)&1 == 1 }
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
	union := func(i, j int) {
		ri, rj := find(i), find(j)
		if ri != rj {
			parent[ri] = rj
		}
	}
	for i := 0; i < n; i++ {
		x := u[i]
		negx := g.neg[x]
		for jj := i + 1; jj < n; jj++ {
			y := u[jj]
			if inAU(g.add[x][y]) || inAU(g.add[x][g.neg[y]]) || inAU(g.add[y][negx]) {
				union(i, jj)
			}
		}
	}
	sizes := map[int]int{}
	for i := 0; i < n; i++ {
		r := find(i)
		sizes[r]++
		if sizes[r] > maxComp {
			maxComp = sizes[r]
		}
	}
	return len(sizes), maxComp
}

// ---------- probe ----------

type depthStat struct {
	nodes       int64
	decomposed  int64
	sumComp     int64
	maxComp     int
	sumU        int64
	sumMaxCsize int64
}

type probe struct {
	g     *Group
	tt    map[Mask]bool
	nodes int64
	stat  map[int]*depthStat
}

func (p *probe) solve(a Mask) bool {
	key := p.g.canon(a)
	if v, ok := p.tt[key]; ok {
		return v
	}
	p.nodes++
	legal := p.g.legalMask(a)
	nc, mc := p.g.numComponents(a, legal)
	d := a.popcount()
	st := p.stat[d]
	if st == nil {
		st = &depthStat{}
		p.stat[d] = st
	}
	st.nodes++
	st.sumComp += int64(nc)
	st.sumU += int64(legal.popcount())
	st.sumMaxCsize += int64(mc)
	if nc >= 2 {
		st.decomposed++
	}
	if nc > st.maxComp {
		st.maxComp = nc
	}

	res := false
	for w := 0; w < W && !res; w++ {
		x := legal[w]
		base := w << 6
		for x != 0 {
			b := bits.TrailingZeros64(x)
			x &= x - 1
			child := a
			child.setBit(base | b)
			if !p.solve(child) {
				res = true
				break
			}
		}
	}
	p.tt[key] = res
	return res
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
		fmt.Fprintln(os.Stderr, "usage: probe <mods>   e.g. probe 3,3,7")
		os.Exit(2)
	}
	mods := parseMods(os.Args[1])
	t0 := time.Now()
	g := newGroup(mods)
	name := make([]string, len(mods))
	for i, m := range mods {
		name[i] = "Z" + strconv.Itoa(m)
	}
	fmt.Printf("[%s] |G|=%d |Aut|=%d\n", strings.Join(name, "x"), g.N, len(g.auto))

	p := &probe{g: g, tt: make(map[Mask]bool, 1<<20), stat: map[int]*depthStat{}}
	var start Mask
	w := p.solve(start)
	outcome := "P"
	if w {
		outcome = "N"
	}
	fmt.Printf("  OUTCOME=%s  explored_nodes=%d  time=%.2fs\n", outcome, p.nodes, time.Since(t0).Seconds())
	fmt.Printf("  decomposition by depth (popcount of A):\n")
	fmt.Printf("    %-5s %-12s %-10s %-9s %-8s %-8s %-9s\n",
		"pc", "nodes", "decomp%", "meanComp", "maxComp", "mean|U|", "meanMaxC")
	var depths []int
	for d := range p.stat {
		depths = append(depths, d)
	}
	sort.Ints(depths)
	var totNodes, totDecomp int64
	for _, d := range depths {
		st := p.stat[d]
		totNodes += st.nodes
		totDecomp += st.decomposed
		fmt.Printf("    %-5d %-12d %-9.1f%% %-9.2f %-8d %-8.1f %-9.2f\n",
			d, st.nodes,
			100*float64(st.decomposed)/float64(st.nodes),
			float64(st.sumComp)/float64(st.nodes),
			st.maxComp,
			float64(st.sumU)/float64(st.nodes),
			float64(st.sumMaxCsize)/float64(st.nodes),
		)
	}
	fmt.Printf("  TOTAL: nodes=%d  decomposed(>=2 comps)=%d (%.1f%%)\n",
		totNodes, totDecomp, 100*float64(totDecomp)/float64(totNodes))
}
