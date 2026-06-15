# cython: language_level=3, boundscheck=False, wraparound=False
"""Native black-centered alpha-beta over packed bitboards.

Same algorithm and values as the Python engines (othello.ai.alphabeta /
alphabeta_move_ordering): bound-tracking TT, fail-soft, optional mobility move
ordering, positional horizon heuristic (matching othello.ai.evaluation). The
whole inner loop runs in C -- no Board objects, native recursion, inlined
make-move / legal-moves / flips.

The transposition table (TT) is a native open-addressing hash table: a flat C
array indexed by a hash of (black, white, to_move, depth). Each slot stores the
full key, so a hash collision just misses and recomputes -- never returns a
wrong entry -- and eviction only costs speed, so values are identical to an
unbounded dict TT (and to the Python engines). Finite depth only.
"""
from libc.stdlib cimport calloc, free
from libc.string cimport memset

cdef extern from *:
    int __builtin_popcountll(unsigned long long x)

ctypedef unsigned long long u64

cdef u64 NOT_A = 0xFEFEFEFEFEFEFEFE
cdef u64 NOT_H = 0x7F7F7F7F7F7F7F7F

cdef int EXACT = 0
cdef int LOWER = 1
cdef int UPPER = 2
cdef int NEG = -1000000000
cdef int POS = 1000000000
cdef int ORDER_MIN_DEPTH = 4

# Horizon heuristic weights (must match othello.ai.evaluation.heuristic).
cdef u64 CORNERS = 0x8100000000000081
cdef int CORNER_W = 25
cdef int MOB_W = 5
cdef int DISC_W = 1


cdef struct Entry:
    u64 black
    u64 white
    int value
    signed char to_move
    signed char depth
    signed char flag
    signed char used


cdef class TranspositionTable:
    """Open-addressing transposition table; 2**bits slots * 24B each, always
    replace on collision. The default (2**16 ~= 1.5MB) is deliberately small so
    it stays in L2/L3 cache -- cache-local probes beat the extra recompute from
    eviction, and a bigger table is measurably slower."""
    cdef Entry* slots
    cdef u64* hint            # position-keyed best-move bit (lossy ordering hint)
    cdef size_t mask

    def __cinit__(self, int bits=16):
        cdef size_t n = (<size_t>1) << bits
        self.mask = n - 1
        self.slots = <Entry*>calloc(n, sizeof(Entry))
        self.hint = <u64*>calloc(n, sizeof(u64))
        if self.slots == NULL or self.hint == NULL:
            raise MemoryError()

    def __dealloc__(self):
        if self.slots != NULL:
            free(self.slots)
        if self.hint != NULL:
            free(self.hint)

    def clear(self):
        memset(self.slots, 0, (self.mask + 1) * sizeof(Entry))
        memset(self.hint, 0, (self.mask + 1) * sizeof(u64))


cdef inline size_t _index(u64 black, u64 white, int to_move, int depth, size_t mask):
    cdef u64 h = black ^ (white * <u64>0x9E3779B97F4A7C15)
    h ^= (<u64>to_move << 1) ^ (<u64>depth << 3)
    h ^= h >> 33
    h = h * <u64>0xFF51AFD7ED558CCD
    h ^= h >> 33
    return <size_t>h & mask


cdef u64 _legal(u64 player, u64 opponent):
    cdef u64 empty = ~(player | opponent)
    cdef u64 moves = 0
    cdef u64 g, p, ep, wp
    g = player; p = opponent
    g |= p & (g << 8);  p &= p << 8
    g |= p & (g << 16); p &= p << 16
    g |= p & (g << 32)
    moves |= ((g & opponent) << 8) & empty
    g = player; p = opponent
    g |= p & (g >> 8);  p &= p >> 8
    g |= p & (g >> 16); p &= p >> 16
    g |= p & (g >> 32)
    moves |= ((g & opponent) >> 8) & empty
    ep = opponent & NOT_A
    g = player; p = ep
    g |= p & (g << 1);  p &= p << 1
    g |= p & (g << 2);  p &= p << 2
    g |= p & (g << 4)
    moves |= (((g & opponent) << 1) & NOT_A) & empty
    g = player; p = ep
    g |= p & (g << 9);  p &= p << 9
    g |= p & (g << 18); p &= p << 18
    g |= p & (g << 36)
    moves |= (((g & opponent) << 9) & NOT_A) & empty
    g = player; p = ep
    g |= p & (g >> 7);  p &= p >> 7
    g |= p & (g >> 14); p &= p >> 14
    g |= p & (g >> 28)
    moves |= (((g & opponent) >> 7) & NOT_A) & empty
    wp = opponent & NOT_H
    g = player; p = wp
    g |= p & (g >> 1);  p &= p >> 1
    g |= p & (g >> 2);  p &= p >> 2
    g |= p & (g >> 4)
    moves |= (((g & opponent) >> 1) & NOT_H) & empty
    g = player; p = wp
    g |= p & (g << 7);  p &= p << 7
    g |= p & (g << 14); p &= p << 14
    g |= p & (g << 28)
    moves |= (((g & opponent) << 7) & NOT_H) & empty
    g = player; p = wp
    g |= p & (g >> 9);  p &= p >> 9
    g |= p & (g >> 18); p &= p >> 18
    g |= p & (g >> 36)
    moves |= (((g & opponent) >> 9) & NOT_H) & empty
    return moves


cdef u64 _flips(u64 move, u64 player, u64 opponent):
    cdef u64 flips = 0
    cdef u64 x, cap
    x = (move & NOT_H) << 1; cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_H) << 1
    if x & player: flips |= cap
    x = (move & NOT_A) >> 1; cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_A) >> 1
    if x & player: flips |= cap
    x = move << 8; cap = 0
    while x & opponent:
        cap |= x; x = x << 8
    if x & player: flips |= cap
    x = move >> 8; cap = 0
    while x & opponent:
        cap |= x; x = x >> 8
    if x & player: flips |= cap
    x = (move & NOT_H) << 9; cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_H) << 9
    if x & player: flips |= cap
    x = (move & NOT_A) << 7; cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_A) << 7
    if x & player: flips |= cap
    x = (move & NOT_H) >> 7; cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_H) >> 7
    if x & player: flips |= cap
    x = (move & NOT_A) >> 9; cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_A) >> 9
    if x & player: flips |= cap
    return flips


cdef inline void _store(Entry* e, u64 black, u64 white, int to_move, int depth,
                        int value, int flag):
    e.black = black; e.white = white; e.to_move = to_move
    e.depth = depth; e.value = value; e.flag = flag; e.used = 1


cdef int _ab(u64 black, u64 white, int to_move, int depth,
             int alpha, int beta, TranspositionTable tt, int order):
    cdef size_t idx = _index(black, white, to_move, depth, tt.mask)
    cdef Entry* e = &tt.slots[idx]
    cdef int a0 = alpha, b0 = beta
    cdef int value, flag, v, child, n, i, j, ckey
    cdef u64 player, opp, moves, om, m, fl, nb, nw
    cdef u64 cb[64]
    cdef u64 cw[64]
    cdef int ck[64]

    if e.used and e.black == black and e.white == white \
            and e.to_move == to_move and e.depth == depth:
        value = e.value; flag = e.flag
        if flag == EXACT:
            return value
        elif flag == LOWER:
            if value > alpha: alpha = value
        else:
            if value < beta: beta = value
        if alpha >= beta:
            return value

    if depth <= 0:                                    # horizon heuristic
        value = (CORNER_W * (__builtin_popcountll(black & CORNERS)
                             - __builtin_popcountll(white & CORNERS))
                 + MOB_W * (__builtin_popcountll(_legal(black, white))
                            - __builtin_popcountll(_legal(white, black)))
                 + DISC_W * (__builtin_popcountll(black) - __builtin_popcountll(white)))
        _store(e, black, white, to_move, depth, value, EXACT)
        return value

    if to_move == 0:
        player = black; opp = white
    else:
        player = white; opp = black
    moves = _legal(player, opp)

    if moves == 0:
        om = _legal(opp, player)
        if om == 0:                                   # terminal
            value = __builtin_popcountll(black) - __builtin_popcountll(white)
            _store(e, black, white, to_move, depth, value, EXACT)
            return value
        value = _ab(black, white, to_move ^ 1, depth - 1, alpha, beta, tt, order)  # pass
        if to_move == 0:
            flag = UPPER if value <= a0 else (LOWER if value >= beta else EXACT)
        else:
            flag = LOWER if value >= b0 else (UPPER if value <= alpha else EXACT)
        _store(e, black, white, to_move, depth, value, flag)
        return value

    child = depth - 1

    n = 0
    while moves:
        m = moves & (~moves + 1); moves ^= m
        fl = _flips(m, player, opp)
        if to_move == 0:
            nb = black | m | fl; nw = white & ~fl
        else:
            nb = black & ~fl; nw = white | m | fl
        cb[n] = nb; cw[n] = nw
        if order and depth >= ORDER_MIN_DEPTH:
            ck[n] = __builtin_popcountll(_legal(nw, nb) if to_move == 0 else _legal(nb, nw))
        n += 1

    if order and depth >= ORDER_MIN_DEPTH and n > 1:
        for i in range(1, n):                         # insertion sort by ck asc
            ckey = ck[i]; nb = cb[i]; nw = cw[i]
            j = i - 1
            while j >= 0 and ck[j] > ckey:
                ck[j + 1] = ck[j]; cb[j + 1] = cb[j]; cw[j + 1] = cw[j]; j -= 1
            ck[j + 1] = ckey; cb[j + 1] = nb; cw[j + 1] = nw

    if to_move == 0:                                  # maximiser (black)
        value = NEG
        for i in range(n):
            v = _ab(cb[i], cw[i], 1, child, alpha, beta, tt, order)
            if v > value:
                value = v
                if v > alpha:
                    alpha = v
                    if alpha >= beta:
                        break
        flag = UPPER if value <= a0 else (LOWER if value >= beta else EXACT)
    else:                                             # minimiser (white)
        value = POS
        for i in range(n):
            v = _ab(cb[i], cw[i], 0, child, alpha, beta, tt, order)
            if v < value:
                value = v
                if v < beta:
                    beta = v
                    if alpha >= beta:
                        break
        flag = LOWER if value >= b0 else (UPPER if value <= alpha else EXACT)

    # `e` still points at this position's slot (the array never moves), though a
    # child may have evicted its contents; overwrite with our result.
    e = &tt.slots[idx]
    _store(e, black, white, to_move, depth, value, flag)
    return value


cpdef int search(u64 black, u64 white, int to_move, int depth,
                 TranspositionTable tt, int order):
    """Black-centered minimax value, `depth` plies; order=1 enables ordering."""
    return _ab(black, white, to_move, depth, NEG, POS, tt, order)


# ---------------------------------------------------------------------------- #
# "Strong" search: negamax principal-variation search (PVS) with a best-move
# hint table, driven by iterative deepening. Pure search-order tricks, so the
# value is identical to plain alpha-beta -- it just prunes far more.
# ---------------------------------------------------------------------------- #

cdef inline size_t _pos_index(u64 black, u64 white, int to_move, size_t mask):
    return _index(black, white, to_move, 0, mask)


cdef int _pvs(u64 black, u64 white, int to_move, int depth,
              int alpha, int beta, TranspositionTable tt, int order):
    # Negamax: returns the value from `to_move`'s perspective.
    cdef size_t idx = _index(black, white, to_move, depth, tt.mask)
    cdef Entry* e = &tt.slots[idx]
    cdef int a0 = alpha
    cdef int value, flag, v, child, n, i, j, ckey, hb, diff
    cdef u64 player, opp, moves, om, m, fl, nb, nw, hint, best
    cdef u64 cb[64]
    cdef u64 cw[64]
    cdef u64 cm[64]
    cdef int ck[64]

    if e.used and e.black == black and e.white == white \
            and e.to_move == to_move and e.depth == depth:
        value = e.value; flag = e.flag
        if flag == EXACT:
            return value
        elif flag == LOWER:
            if value > alpha: alpha = value
        else:
            if value < beta: beta = value
        if alpha >= beta:
            return value

    if depth <= 0:                                    # horizon heuristic (negamax)
        hb = (CORNER_W * (__builtin_popcountll(black & CORNERS)
                          - __builtin_popcountll(white & CORNERS))
              + MOB_W * (__builtin_popcountll(_legal(black, white))
                         - __builtin_popcountll(_legal(white, black)))
              + DISC_W * (__builtin_popcountll(black) - __builtin_popcountll(white)))
        value = hb if to_move == 0 else -hb
        _store(e, black, white, to_move, depth, value, EXACT)
        return value

    if to_move == 0:
        player = black; opp = white
    else:
        player = white; opp = black
    moves = _legal(player, opp)

    if moves == 0:
        om = _legal(opp, player)
        if om == 0:                                   # terminal (negamax)
            diff = __builtin_popcountll(black) - __builtin_popcountll(white)
            value = diff if to_move == 0 else -diff
            _store(e, black, white, to_move, depth, value, EXACT)
            return value
        value = -_pvs(black, white, to_move ^ 1, depth - 1, -beta, -alpha, tt, order)  # pass
        flag = UPPER if value <= a0 else (LOWER if value >= beta else EXACT)
        _store(e, black, white, to_move, depth, value, flag)
        return value

    child = depth - 1

    n = 0
    while moves:
        m = moves & (~moves + 1); moves ^= m
        fl = _flips(m, player, opp)
        if to_move == 0:
            nb = black | m | fl; nw = white & ~fl
        else:
            nb = black & ~fl; nw = white | m | fl
        cb[n] = nb; cw[n] = nw; cm[n] = m
        if order and depth >= ORDER_MIN_DEPTH:
            ck[n] = __builtin_popcountll(_legal(nw, nb) if to_move == 0 else _legal(nb, nw))
        n += 1

    if order and depth >= ORDER_MIN_DEPTH and n > 1:  # mobility ordering
        for i in range(1, n):
            ckey = ck[i]; nb = cb[i]; nw = cw[i]; m = cm[i]
            j = i - 1
            while j >= 0 and ck[j] > ckey:
                ck[j+1] = ck[j]; cb[j+1] = cb[j]; cw[j+1] = cw[j]; cm[j+1] = cm[j]; j -= 1
            ck[j+1] = ckey; cb[j+1] = nb; cw[j+1] = nw; cm[j+1] = m

    hint = tt.hint[_pos_index(black, white, to_move, tt.mask)]
    if hint:                                          # try the hash move first
        for i in range(n):
            if cm[i] == hint:
                if i != 0:
                    nb = cb[i]; nw = cw[i]; m = cm[i]
                    for j in range(i, 0, -1):
                        cb[j] = cb[j-1]; cw[j] = cw[j-1]; cm[j] = cm[j-1]
                    cb[0] = nb; cw[0] = nw; cm[0] = m
                break

    value = NEG; best = cm[0]
    for i in range(n):
        if i == 0:
            v = -_pvs(cb[i], cw[i], to_move ^ 1, child, -beta, -alpha, tt, order)
        else:
            v = -_pvs(cb[i], cw[i], to_move ^ 1, child, -alpha - 1, -alpha, tt, order)
            if alpha < v and v < beta:                # scout failed high -> re-search
                v = -_pvs(cb[i], cw[i], to_move ^ 1, child, -beta, -alpha, tt, order)
        if v > value:
            value = v; best = cm[i]
        if v > alpha:
            alpha = v
        if alpha >= beta:
            break

    flag = UPPER if value <= a0 else (LOWER if value >= beta else EXACT)
    e = &tt.slots[idx]
    _store(e, black, white, to_move, depth, value, flag)
    tt.hint[_pos_index(black, white, to_move, tt.mask)] = best
    return value


cpdef int search_strong(u64 black, u64 white, int to_move, int depth,
                        TranspositionTable tt, int order):
    """Iterative-deepening PVS; returns the black-centered value (== search).

    NB: stores negamax (side-to-move) values in `tt`, whereas search() stores
    black-centered ones -- do not share a TranspositionTable between them.
    """
    cdef int v = 0, d
    if depth <= 0:
        v = _pvs(black, white, to_move, depth, NEG, POS, tt, order)
    else:
        for d in range(1, depth + 1):
            v = _pvs(black, white, to_move, d, NEG, POS, tt, order)
    return v if to_move == 0 else -v
