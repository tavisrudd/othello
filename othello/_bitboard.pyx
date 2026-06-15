# cython: language_level=3, boundscheck=False, wraparound=False
"""Native uint64 bitboard kernels.

Bit-identical to the pure-Python Board._legal_moves / _flips_for_move (see
core.py), which stay as the reference + fallback; othello.core swaps these in
when the compiled extension is present. uint64 arithmetic wraps natively, so the
explicit `& FULL` the Python versions need is implicit here.
"""

ctypedef unsigned long long u64

cdef u64 NOT_A = 0xFEFEFEFEFEFEFEFE   # no file A
cdef u64 NOT_H = 0x7F7F7F7F7F7F7F7F   # no file H


cpdef u64 legal_moves(u64 player, u64 opponent):
    # Kogge-Stone occluded fill per ray (3 shift-doubling steps).
    cdef u64 empty = ~(player | opponent)
    cdef u64 moves = 0
    cdef u64 g, p, ep, wp

    g = player; p = opponent                              # north
    g |= p & (g << 8);  p &= p << 8
    g |= p & (g << 16); p &= p << 16
    g |= p & (g << 32)
    moves |= ((g & opponent) << 8) & empty

    g = player; p = opponent                              # south
    g |= p & (g >> 8);  p &= p >> 8
    g |= p & (g >> 16); p &= p >> 16
    g |= p & (g >> 32)
    moves |= ((g & opponent) >> 8) & empty

    ep = opponent & NOT_A                                 # rightward (mask file A)
    g = player; p = ep                                    # east
    g |= p & (g << 1);  p &= p << 1
    g |= p & (g << 2);  p &= p << 2
    g |= p & (g << 4)
    moves |= (((g & opponent) << 1) & NOT_A) & empty

    g = player; p = ep                                    # northeast
    g |= p & (g << 9);  p &= p << 9
    g |= p & (g << 18); p &= p << 18
    g |= p & (g << 36)
    moves |= (((g & opponent) << 9) & NOT_A) & empty

    g = player; p = ep                                    # southeast
    g |= p & (g >> 7);  p &= p >> 7
    g |= p & (g >> 14); p &= p >> 14
    g |= p & (g >> 28)
    moves |= (((g & opponent) >> 7) & NOT_A) & empty

    wp = opponent & NOT_H                                 # leftward (mask file H)
    g = player; p = wp                                    # west
    g |= p & (g >> 1);  p &= p >> 1
    g |= p & (g >> 2);  p &= p >> 2
    g |= p & (g >> 4)
    moves |= (((g & opponent) >> 1) & NOT_H) & empty

    g = player; p = wp                                    # northwest
    g |= p & (g << 7);  p &= p << 7
    g |= p & (g << 14); p &= p << 14
    g |= p & (g << 28)
    moves |= (((g & opponent) << 7) & NOT_H) & empty

    g = player; p = wp                                    # southwest
    g |= p & (g >> 9);  p &= p >> 9
    g |= p & (g >> 18); p &= p >> 18
    g |= p & (g >> 36)
    moves |= (((g & opponent) >> 9) & NOT_H) & empty

    return moves


cpdef u64 flips_for_move(u64 move, u64 player, u64 opponent):
    # Per ray: walk the contiguous opponent run from `move`; if it ends on one
    # of ours, capture it. The while loop early-exits when the run ends.
    cdef u64 flips = 0
    cdef u64 x, cap

    x = (move & NOT_H) << 1                               # east
    cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_H) << 1
    if x & player: flips |= cap

    x = (move & NOT_A) >> 1                               # west
    cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_A) >> 1
    if x & player: flips |= cap

    x = move << 8                                         # north
    cap = 0
    while x & opponent:
        cap |= x; x = x << 8
    if x & player: flips |= cap

    x = move >> 8                                         # south
    cap = 0
    while x & opponent:
        cap |= x; x = x >> 8
    if x & player: flips |= cap

    x = (move & NOT_H) << 9                               # northeast
    cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_H) << 9
    if x & player: flips |= cap

    x = (move & NOT_A) << 7                               # northwest
    cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_A) << 7
    if x & player: flips |= cap

    x = (move & NOT_H) >> 7                               # southeast
    cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_H) >> 7
    if x & player: flips |= cap

    x = (move & NOT_A) >> 9                               # southwest
    cap = 0
    while x & opponent:
        cap |= x; x = (x & NOT_A) >> 9
    if x & player: flips |= cap

    return flips
