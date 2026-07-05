/* Grundy solver for the interval-family octal game  0.[1xk][3xk]7.
 *
 *   digits: d_1..d_k     = 1   (bit0: remove i tokens iff it empties the heap)
 *           d_{k+1}..2k  = 3   (bit0|bit1: leave 0 or 1 nonempty heap)
 *           d_{2k+1}     = 7   (bit0|bit1|bit2: leave 0, 1, or 2 heaps)
 *   r = 2k+1 = largest heap-size that can be taken.
 *
 * G(m) = mex over legal moves. Only the single 7-digit (i=2k+1) splits, so the
 * cost is O(m) per heap (the split scan) => O(M^2) total. Validated on k=1
 * (0.137 = Dawson's chess, period 34, preperiod 52, max 9).
 *
 * Reports: max Grundy value + argmax, checkpoint values, and a pure/arithmetic
 * period scan on the tail (Guy-Smith window certification).
 *
 *   usage: ./octal <k> <M> [Pmax]
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
    if (argc < 3) { fprintf(stderr, "usage: %s k M [Pmax]\n", argv[0]); return 1; }
    int k = atoi(argv[1]);
    long M = atol(argv[2]);
    long Pmax = (argc > 3) ? atol(argv[3]) : 6000;
    int r = 2 * k + 1;

    /* digit[i] for i=1..r */
    int *digit = calloc(r + 1, sizeof(int));
    for (int i = 1; i <= k; i++) digit[i] = 1;
    for (int i = k + 1; i <= 2 * k; i++) digit[i] = 3;
    digit[2 * k + 1] = 7;

    int *G = malloc((M + 1) * sizeof(int));
    if (!G) { fprintf(stderr, "OOM G\n"); return 1; }

    /* mex scratch: seen[v] = timestamp of last heap that produced option v. */
    long seencap = 1 << 20;
    long *seen = malloc(seencap * sizeof(long));
    for (long i = 0; i < seencap; i++) seen[i] = -1;

    /* geometric checkpoints for the record curve */
    long gck[] = {1000,3000,10000,30000,100000,300000,1000000,2000000,4000000};
    int ngck = sizeof(gck)/sizeof(gck[0]);
    int *gmax = calloc(ngck, sizeof(int));

    int maxval = 0; long argmax = 0;
    long last_zero = 0;            /* last m>=1 with G[m]==0 (last path P-position) */
    G[0] = 0;
    for (long m = 1; m <= M; m++) {
        long ts = m;               /* unique timestamp for this heap */
        /* one-heap and whole-heap removals: i = 1..r */
        for (int i = 1; i <= r && i <= m; i++) {
            int d = digit[i];
            if ((d & 1) && i == m) { if (0 < seencap) seen[0] = ts; }
            if ((d & 2) && m - i > 0) { int v = G[m - i]; if (v < seencap) seen[v] = ts; }
        }
        /* split: only the single 7-digit at i = r, leaving two nonempty heaps */
        if (r <= m && (digit[r] & 4)) {
            long rem = m - r;                 /* tokens left, split into a+b>0 */
            for (long a = 1; a < rem; a++) {
                int v = G[a] ^ G[rem - a];
                if (v < seencap) seen[v] = ts;
            }
        }
        int mex = 0;
        while (mex < seencap && seen[mex] == ts) mex++;
        G[m] = mex;
        if (mex > maxval) { maxval = mex; argmax = m; }
        if (mex == 0) last_zero = m;
        for (int c = 0; c < ngck; c++) if (m <= gck[c] && maxval > gmax[c]) gmax[c] = maxval;
    }
    /* fill checkpoints beyond M with the final record for readability */


    printf("octal 0.[1x%d][3x%d]7  (r=%d)  M=%ld\n", k, k, r, M);
    printf("max Grundy value = %d  at m=%ld\n", maxval, argmax);
    printf("record curve (max over [0,m]):");
    for (int c = 0; c < ngck; c++) if (gck[c] <= M) printf("  m=%ld:%d", gck[c], gmax[c]);
    printf("\n");
    printf("last P-position (last m with G=0) = %ld\n", last_zero);
    printf("checkpoints G(m):");
    long cps[] = {100, 1000, 8000, 20000, 50000, 100000, 200000, 500000, M};
    for (unsigned i = 0; i < sizeof(cps)/sizeof(cps[0]); i++)
        if (cps[i] <= M) printf("  G(%ld)=%d", cps[i], G[cps[i]]);
    printf("\n");

    /* running max over windows (firm up unbounded growth) */
    printf("window-max: ");
    long win = M / 10; if (win < 1) win = 1;
    for (long w = 0; w < M; w += win) {
        int wm = 0; long hi = w + win; if (hi > M) hi = M + 1;
        for (long m = w; m < hi; m++) if (G[m] > wm) wm = G[m];
        printf("[%ld]=%d ", w, wm);
    }
    printf("\n");

    /* PERIOD SCAN on the tail. Guy-Smith: a pure period p certified from n0 if
     * G(n)=G(n-p) for all n0 <= n <= 2*n0 + p + r. We scan p, test the tail
     * window, and report the smallest certified period (pure and arithmetic). */
    long start = M / 2;
    long found_pure = 0, found_arith = 0, found_saltus = 0;
    for (long p = 1; p <= Pmax; p++) {
        /* pure period on [start, M] */
        int ok = 1;
        for (long m = start + p; m <= M; m++) if (G[m] != G[m - p]) { ok = 0; break; }
        if (ok) { found_pure = p; break; }
    }
    for (long p = 1; p <= Pmax && !found_arith; p++) {
        /* arithmetic period: G(m) = G(m-p) + s, constant integer saltus s */
        int s = G[start + p] - G[start];
        if (s < 0) continue;
        int ok = 1;
        for (long m = start + p; m <= M; m++) if (G[m] != G[m - p] + s) { ok = 0; break; }
        if (ok) { found_arith = p; found_saltus = s; }
    }
    if (found_pure) printf("PURE PERIOD found: p=%ld on tail [%ld,%ld]\n", found_pure, start, M);
    else            printf("NO pure period for p<=%ld on tail [%ld,%ld]\n", Pmax, start, M);
    if (found_arith) printf("ARITHMETIC PERIOD found: p=%ld saltus=%d on tail [%ld,%ld]\n",
                            found_arith, found_saltus, start, M);
    else             printf("NO arithmetic period (saltus>=0) for p<=%ld on tail [%ld,%ld]\n", Pmax, start, M);

    free(G); free(seen); free(digit);
    return 0;
}
