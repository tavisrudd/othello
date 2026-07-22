// Exact C468 trace counter over F_{31^5}.
//
// The field is F_31[t]/(t^5+t+11), and g=t+1 is primitive.  For the
// curve reduction
//   T(q)=sum_C chi(-4*x2),
//   C: x2*x3^4-4*x2^3*x3+1=0,
// write x2=g^i, x3=g^j.  If la=i+4j and
// d=log_g(-4)+2i-3j, the curve equation is
// la+zech(d)=log_g(-1).  The linear map (i,j)->(la,d-log_g(-4))
// has determinant -11.  This reduces the O(q^2) curve scan to O(q).

const P: usize = 31;
const K: usize = 5;
const Q: usize = 28_629_151;
const M: usize = Q - 1;

fn mul_by_g(x: usize) -> usize {
    let mut a = [0usize; K];
    let mut y = x;
    for v in &mut a {
        *v = y % P;
        y /= P;
    }
    // g=t+1 and t^5=-t-11=30t+20.
    let b = [
        (a[0] + 20 * a[4]) % P,
        (a[1] + a[0] + 30 * a[4]) % P,
        (a[2] + a[1]) % P,
        (a[3] + a[2]) % P,
        (a[4] + a[3]) % P,
    ];
    b[0] + P * (b[1] + P * (b[2] + P * (b[3] + P * b[4])))
}

fn add_one(x: usize) -> usize {
    let c = x % P;
    x - c + (c + 1) % P
}

fn normalize(mut a: Vec<i128>) -> Vec<i128> {
    for s in 0..11 {
        let z = a[30 * 11 + s];
        for r in 0..30 {
            a[r * 11 + s] -= z;
        }
        a[30 * 11 + s] = 0;
    }
    for r in 0..31 {
        let z = a[r * 11 + 10];
        for s in 0..10 {
            a[r * 11 + s] -= z;
        }
        a[r * 11 + 10] = 0;
    }
    a
}

fn mul_cyclotomic(a: &[i128], b: &[i128]) -> Vec<i128> {
    let mut c = vec![0i128; 31 * 11];
    for r1 in 0..31 {
        for s1 in 0..11 {
            let x = a[r1 * 11 + s1];
            if x == 0 {
                continue;
            }
            for r2 in 0..31 {
                for s2 in 0..11 {
                    let y = b[r2 * 11 + s2];
                    if y != 0 {
                        c[((r1 + r2) % 31) * 11 + (s1 + s2) % 11] += x * y;
                    }
                }
            }
        }
    }
    normalize(c)
}

fn gauss(counts: &[[i64; 11]; 31], exponent: usize) -> Vec<i128> {
    let mut a = vec![0i128; 31 * 11];
    for r in 0..31 {
        for s in 0..11 {
            a[r * 11 + (exponent * s) % 11] += counts[r][s] as i128;
        }
    }
    normalize(a)
}

fn main() {
    let mut exp = vec![0u32; M];
    let mut log = vec![u32::MAX; Q];
    let mut counts = [[0i64; 11]; 31];
    let mut x = 1usize;
    for (i, slot) in exp.iter_mut().enumerate() {
        assert_ne!(x, 0);
        assert_eq!(log[x], u32::MAX, "g is not primitive at exponent {i}");
        *slot = x as u32;
        log[x] = i as u32;
        let a0 = x % P;
        let a4 = (x / P.pow(4)) % P;
        let trace = (5 * a0 + 27 * a4) % P;
        counts[trace][i % 11] += 1;
        x = mul_by_g(x);
    }
    assert_eq!(x, 1);

    let half = M / 2;
    let ln4 = log[P - 4] as usize;
    assert_ne!(ln4, u32::MAX as usize);
    let mut total = 0i64;
    let mut contributing_d = 0u64;
    for d in 0..M {
        let s = add_one(exp[d] as usize);
        if s == 0 {
            assert_eq!(d, half);
            continue;
        }
        let z = log[s] as usize;
        let la = (half + M - z) % M;
        let delta = (d + M - ln4) % M;
        if (delta + 22 - 2 * (la % 11)) % 11 != 0 {
            continue;
        }
        let rhs = (3 * la + 4 * delta) % M;
        assert_eq!(rhs % 11, 0);
        let i0 = rhs / 11;
        let sign = if (ln4 + i0) % 2 == 0 { 1 } else { -1 };
        total += 11 * sign;
        contributing_d += 1;
    }
    let q = Q as i64;
    let trace = -q * (1 + total);
    println!(
        "curve q={Q} log_minus4={ln4} contributing_d={contributing_d} T={total} trace={trace}"
    );

    // Exact Delsarte/Gauss-sum cross-check in
    // Z[zeta_31,zeta_11], represented in the 30*10 power basis.
    let mut sum = vec![0i128; 31 * 11];
    for a in 1..11 {
        let exponents = [a, 5 * a % 11, 3 * a % 11, 4 * a % 11, 9 * a % 11];
        let mut product = vec![0i128; 31 * 11];
        product[0] = 1;
        for e in exponents {
            product = mul_cyclotomic(&product, &gauss(&counts, e));
        }
        for i in 0..sum.len() {
            sum[i] += product[i];
        }
    }
    let gauss_sum = sum[0];
    sum[0] = 0;
    assert!(sum.iter().all(|&v| v == 0), "Gauss sum is not rational");
    assert_eq!(-gauss_sum / Q as i128, trace as i128);
    assert_eq!(gauss_sum % Q as i128, 0);
    println!(
        "gauss product_sum={gauss_sum} trace={}",
        -gauss_sum / Q as i128
    );
}
