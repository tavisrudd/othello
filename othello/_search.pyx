# cython: language_level=3, boundscheck=False, wraparound=False
"""Native black-centered alpha-beta over packed bitboards.

Same algorithm and values as the Python engines (othello.ai.alphabeta /
alphabeta_move_ordering): bound-tracking TT, fail-soft, optional mobility move
ordering. The whole inner loop runs in C -- no Board objects, native recursion,
inlined make-move / legal-moves / flips. The TT is a Python dict keyed by
(black, white, to_move, depth) with (value, flag) entries (flag 0=exact 1=lower
2=upper). `order=1` enables mobility ordering (fewest opponent replies first)
for nodes with >= ORDER_MIN_DEPTH plies left. Finite depth only.
"""

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


cdef int _ab(u64 black, u64 white, int to_move, int depth,
             int alpha, int beta, dict tt, int order):
    cdef tuple key = (black, white, to_move, depth)
    cdef int a0 = alpha, b0 = beta
    cdef int value, flag, v, child, n, i, j, ckey
    cdef u64 player, opp, moves, om, m, fl, nb, nw
    cdef u64 cb[64]
    cdef u64 cw[64]
    cdef int ck[64]

    cdef object entry = tt.get(key)
    if entry is not None:
        value = entry[0]; flag = entry[1]
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
        tt[key] = (value, EXACT)
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
            tt[key] = (value, EXACT)
            return value
        value = _ab(black, white, to_move ^ 1, depth - 1, alpha, beta, tt, order)  # pass
        if to_move == 0:
            flag = UPPER if value <= a0 else (LOWER if value >= beta else EXACT)
        else:
            flag = LOWER if value >= b0 else (UPPER if value <= alpha else EXACT)
        tt[key] = (value, flag)
        return value

    child = depth - 1

    # Build child boards once; sort by opponent mobility when ordering pays off.
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
            # fewest opponent (child side-to-move) replies first
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

    tt[key] = (value, flag)
    return value


cpdef int search(u64 black, u64 white, int to_move, int depth, dict tt, int order):
    """Black-centered minimax value, `depth` plies; order=1 enables ordering."""
    return _ab(black, white, to_move, depth, NEG, POS, tt, order)
