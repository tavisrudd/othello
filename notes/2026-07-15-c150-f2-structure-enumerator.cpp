#include <algorithm>
#include <array>
#include <cassert>
#include <bitset>
#include <cstdint>
#include <iostream>
#include <limits>
#include <map>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

using V = std::array<int, 3>;
using Mat = std::array<int, 9>;

struct LegalRange {
  int lo = std::numeric_limits<int>::max();
  int hi = std::numeric_limits<int>::min();
  uint64_t count = 0;
};

struct FrontierRecord {
  int other = std::numeric_limits<int>::max();
  int fixedFirst = 0;
  int occupiedFirst = 0;
  int emptyFirst = 0;
  int fixedMoment = 0;
  int occupiedMoment = 0;
  int emptyMoment = 0;
  std::array<int,5> multiplicity{};
};

void observe(std::map<std::vector<int>, LegalRange> &table,
             std::initializer_list<int> key, int legal) {
  auto &r = table[std::vector<int>(key)];
  r.lo = std::min(r.lo, legal);
  r.hi = std::max(r.hi, legal);
  ++r.count;
}

void summarize(const std::string &name,
               const std::map<std::vector<int>, LegalRange> &table) {
  size_t nondetermined = 0;
  int maxWidth = 0;
  uint64_t arcsInNondetermined = 0;
  for (const auto &[key, r] : table) {
    (void)key;
    if (r.lo != r.hi) {
      ++nondetermined;
      arcsInNondetermined += r.count;
      maxWidth = std::max(maxWidth, r.hi - r.lo);
    }
  }
  std::cout << "feature=" << name << " keys=" << table.size()
            << " nondetermined_keys=" << nondetermined
            << " nondetermined_arcs=" << arcsInNondetermined
            << " max_legal_width=" << maxWidth << "\n";
}

int add25(int x, int y) {
  return ((x % 5 + y % 5) % 5) + 5 * (((x / 5 + y / 5) % 5));
}
int neg25(int x) { return ((-x % 5) + 5) % 5 + 5 * (((-(x / 5) % 5) + 5) % 5); }
int sub25(int x, int y) { return add25(x, neg25(y)); }
int mul25(int x, int y) {
  int a = x % 5, b = x / 5, c = y % 5, d = y / 5;
  return ((a*c + 2*b*d) % 5) + 5 * ((a*d + b*c) % 5);
}
int pow25(int x, int n) {
  int out = 1;
  while (n) { if (n & 1) out = mul25(out, x); x = mul25(x, x); n >>= 1; }
  return out;
}
int inv25(int x) { assert(x); return pow25(x, 23); }
V norm(V v) {
  int z = 0; while (!v[z]) ++z;
  int zi = inv25(v[z]);
  for (int &x : v) x = mul25(x, zi);
  return v;
}
int key(V v) { return v[0] + 25*v[1] + 625*v[2]; }
int projectiveRank(V v) {
  if (v[0] == 1) return v[1] * 25 + v[2];
  if (v[1] == 1) return 625 + v[2];
  return 650;
}
int leanOrbitNumber(V p, V q) {
  V v = projectiveRank(p) < projectiveRank(q) ? p : q;
  if (v[0] == 1) {
    int yReal = v[1] % 5, yImag = v[1] / 5;
    if (yImag) { assert(yImag == 1 || yImag == 2); return (yReal * 2 + yImag - 1) * 25 + v[2]; }
    int zReal = v[2] % 5, zImag = v[2] / 5;
    assert(zImag == 1 || zImag == 2);
    return 250 + (yReal * 5 + zReal) * 2 + zImag - 1;
  }
  int zReal = v[2] % 5, zImag = v[2] / 5;
  assert(v[1] == 1 && (zImag == 1 || zImag == 2));
  return 300 + zReal * 2 + zImag - 1;
}
V cross(V a, V b) {
  return norm({sub25(mul25(a[1],b[2]),mul25(a[2],b[1])),
               sub25(mul25(a[2],b[0]),mul25(a[0],b[2])),
               sub25(mul25(a[0],b[1]),mul25(a[1],b[0]))});
}
int dot(V a, V b) {
  return add25(add25(mul25(a[0],b[0]),mul25(a[1],b[1])),mul25(a[2],b[2]));
}
V frob(V v) { for (int &x : v) x = pow25(x,5); return norm(v); }

int det5(const Mat &m) {
  int d = m[0]*(m[4]*m[8]-m[5]*m[7])
        - m[1]*(m[3]*m[8]-m[5]*m[6])
        + m[2]*(m[3]*m[7]-m[4]*m[6]);
  d %= 5;
  return d < 0 ? d + 5 : d;
}

V applyMat(const Mat &m, V v) {
  V out{};
  for (int i=0;i<3;++i)
    for (int j=0;j<3;++j)
      out[i] = add25(out[i], mul25(m[3*i+j], v[j]));
  return norm(out);
}

int main(int argc, char **argv) {
  std::vector<V> pts;
  std::unordered_map<int,int> id;
  for (int a=0;a<25;++a) for(int b=0;b<25;++b) for(int c=0;c<25;++c) {
    if (!(a||b||c)) continue;
    V v=norm({a,b,c}); int k=key(v);
    if (!id.count(k)) { id[k]=pts.size(); pts.push_back(v); }
  }
  assert(pts.size()==651);
  std::vector<int> sigma(651), fixed;
  for (int i=0;i<651;++i) { sigma[i]=id.at(key(frob(pts[i]))); if(sigma[i]==i) fixed.push_back(i); }
  assert(fixed.size()==31);
  std::vector<std::pair<int,int>> orb;
  for(int i=0;i<651;++i) if(i<sigma[i]) orb.push_back({i,sigma[i]});
  assert(orb.size()==310);
  std::vector<std::vector<int>> linePts(651);
  for(int l=0;l<651;++l) for(int p=0;p<651;++p) if(dot(pts[p],pts[l])==0) linePts[l].push_back(p);
  for(auto &x:linePts) assert(x.size()==26);
  std::vector<std::vector<int>> join(651,std::vector<int>(651,-1));
  for(int a=0;a<651;++a) for(int b=a+1;b<651;++b) join[a][b]=join[b][a]=id.at(key(cross(pts[a],pts[b])));

  int A=fixed[0], B=fixed[1];
  std::vector<Mat> residualGroup;
  constexpr int matrixCount = 1953125; // 5^9
  for (int code=0;code<matrixCount;++code) {
    int x=code; Mat m{};
    for (int j=0;j<9;++j) { m[j]=x%5; x/=5; }
    auto first = std::find_if(m.begin(),m.end(),[](int a){return a!=0;});
    if (first==m.end() || *first!=1 || det5(m)==0) continue;
    if (id.at(key(applyMat(m,pts[A])))!=A || id.at(key(applyMat(m,pts[B])))!=B) continue;
    residualGroup.push_back(m);
  }
  assert(residualGroup.size()==400);
  std::cerr << "residual_group=" << residualGroup.size() << "\n";
  std::vector<int> orbitOfPoint(651,-1);
  for(int t=0;t<310;++t) {
    orbitOfPoint[orb[t].first]=t;
    orbitOfPoint[orb[t].second]=t;
  }
  std::vector<int> orbitByLeanNumber(310,-1);
  for(int t=0;t<310;++t) {
    int n=leanOrbitNumber(pts[orb[t].first],pts[orb[t].second]);
    assert(orbitByLeanNumber[n]<0); orbitByLeanNumber[n]=t;
  }
  if(argc==3 && std::string(argv[1])=="--lean-row") {
    int bn=std::stoi(argv[2]); assert(0<=bn && bn<310);
    const int coverNumbers[16]={59,39,85,168,147,219,237,183,116,249,167,60,196,231,114,157};
    int oa=orbitByLeanNumber[5], ob=orbitByLeanNumber[bn];
    auto arc = [&](const std::vector<int> &C) {
      for(size_t x=0;x<C.size();++x) for(size_t y=x+1;y<C.size();++y)
        for(size_t z=y+1;z<C.size();++z)
          if(dot(pts[C[z]],pts[join[C[x]][C[y]]])==0) return false;
      return true;
    };
    for(int cn=0;cn<310;++cn) {
      if(!(5<bn && bn<cn)) { std::cout<<cn<<" X\n"; continue; }
      int oc=orbitByLeanNumber[cn];
      std::vector<int> C={A,B,orb[oa].first,orb[oa].second,
        orb[ob].first,orb[ob].second,orb[oc].first,orb[oc].second};
      bool emitted=false;
      for(int x=0;x<8&&!emitted;++x) for(int y=x+1;y<8&&!emitted;++y)
        for(int z=y+1;z<8;++z) if(dot(pts[C[z]],pts[join[C[x]][C[y]]])==0) {
          std::cout<<cn<<" B "<<x<<" "<<y<<" "<<z<<"\n"; emitted=true; break;
        }
      if(emitted) continue;
      assert(arc(C));
      for(int qn:coverNumbers) {
        int oq=orbitByLeanNumber[qn];
        std::vector<int> D=C; D.push_back(orb[oq].first); D.push_back(orb[oq].second);
        if(arc(D)) { std::cout<<cn<<" L "<<qn<<"\n"; emitted=true; break; }
      }
      assert(emitted);
    }
    return 0;
  }
  std::vector<int> good;
  for(int i=0;i<310;++i) {
    std::array<int,4> C={A,B,orb[i].first,orb[i].second}; bool ok=true;
    for(int x=0;x<4;++x) for(int y=x+1;y<4;++y) for(int z=y+1;z<4;++z)
      if(dot(pts[C[z]],pts[join[C[x]][C[y]]])==0) ok=false;
    if(ok) good.push_back(i);
  }
  std::cerr << "points="<<pts.size()<<" orbits="<<orb.size()<<" good="<<good.size()<<"\n";
  int n=good.size();
  std::vector<std::vector<uint8_t>> compat(n,std::vector<uint8_t>(n));
  for(int ii=0;ii<n;++ii) for(int jj=ii+1;jj<n;++jj) {
    int i=good[ii],j=good[jj];
    std::array<int,6> C={A,B,orb[i].first,orb[i].second,orb[j].first,orb[j].second}; bool ok=true;
    for(int x=0;x<6&&ok;++x) for(int y=x+1;y<6&&ok;++y) for(int z=y+1;z<6;++z)
      if(dot(pts[C[z]],pts[join[C[x]][C[y]]])==0) {ok=false;break;}
    compat[ii][jj]=compat[jj][ii]=ok;
  }
  uint64_t arcs=0; int best=1000000, minB=1000, minR=1000, maxFixedMoment=0, maxOccupiedMoment=0,
      minEmptyMoment=1000;
  int minEmptyByType[3][3]; for(auto &row:minEmptyByType) for(int &x:row) x=1000;
  std::array<int,3> bestI{};
  std::vector<std::bitset<310>> normalizedLegalMasks;
  std::vector<uint8_t> selected(651), occupied(651), covered(651), index(651);
  std::map<int, uint64_t> legalHistogram;
  std::map<std::array<int,2>, uint64_t> brHistogram;
  std::set<std::array<int,3>> equalityArcs;
  std::map<int, int> minRByB, minBByR;
  std::map<int, int> minTByB, maxHighCorrectionByB, maxFixedPlusOccupiedByB;
  std::map<int, FrontierRecord> frontierByB;
  std::map<std::vector<int>, uint64_t> equalityTuples;
  std::map<std::vector<int>, LegalRange> byMoments, byBMoments, byRMoments,
      byFirstMoments, byAllMoments, byBEmptyMoment, byREmptyMoment,
      byTailMultiplicity, byFullTuple;
  for(int ii=0;ii<n;++ii) for(int jj=ii+1;jj<n;++jj) if(compat[ii][jj]) {
    for(int kk=jj+1;kk<n;++kk) if(compat[ii][kk]&&compat[jj][kk]) {
      int oi=good[ii],oj=good[jj],ok=good[kk];
      std::array<int,8> C={A,B,orb[oi].first,orb[oi].second,orb[oj].first,orb[oj].second,orb[ok].first,orb[ok].second};
      bool arc=true;
      for(int x=2;x<4&&arc;++x) for(int y=4;y<6&&arc;++y) for(int z=6;z<8;++z)
        if(dot(pts[C[z]],pts[join[C[x]][C[y]]])==0) {arc=false;break;}
      if(!arc) continue;
      ++arcs;
      std::fill(selected.begin(),selected.end(),0);
      std::fill(occupied.begin(),occupied.end(),0);
      std::fill(covered.begin(),covered.end(),0);
      std::fill(index.begin(),index.end(),0);
      for(int p:C) selected[p]=1;
      for(int p:C) if(sigma[p]==p) for(int l:linePts[p]) if(sigma[l]==l) occupied[l]=1;
      for(int t : {oi,oj,ok}) occupied[join[orb[t].first][orb[t].second]]=1;
      int occ=0; for(int l:fixed) occ+=occupied[l]; assert(occ==14);
      for(int x=0;x<8;++x) for(int y=x+1;y<8;++y) {
        int l=join[C[x]][C[y]]; for(int p:linePts[l]) { covered[p]=1; ++index[p]; }
      }
      int legal=0, R=0, candidateCount=0;
      std::array<int,5> multiplicity{};
      std::bitset<310> legalMask;
      for(int t=0;t<310;++t) {
        int p=orb[t].first,q=orb[t].second;
        if(selected[p]||occupied[join[p][q]]) continue;
        assert(index[p]==index[q]);
        assert(index[p] <= 4);
        ++candidateCount;
        ++multiplicity[index[p]];
        if(!covered[p]) { assert(!covered[q]); ++legal; legalMask.set(t); }
        else R += index[p]-1;
      }
      assert(candidateCount == 170 && multiplicity[0] == legal);
      int Bcorr=legal+34-R;
      // Orbit 65 in this enumerator is orbit number 5 in the Lean encoding: the standard orbit
      // used after equivariant four-point normalization.
      if (oi==65 || oj==65 || ok==65) normalizedLegalMasks.push_back(legalMask);
      int ff=0,of=0,ef=0,fm=0,om=0;
      for(int p=0;p<651;++p) if(!selected[p]) {
        int z=index[p]*(index[p]-1)/2;
        if(sigma[p]==p) { ff+=index[p]; fm+=z; }
        else if(occupied[join[p][sigma[p]]]) { of+=index[p]; om+=z; }
        else ef+=index[p];
      }
      assert(ff+of+ef==672 && ef==2*(204-Bcorr));
      minB=std::min(minB,Bcorr); minR=std::min(minR,R);
      maxFixedMoment=std::max(maxFixedMoment,fm); maxOccupiedMoment=std::max(maxOccupiedMoment,om);
      int emptyByType[3][3]{};
      for(int a=0;a<8;++a) for(int b=a+1;b<8;++b) for(int c=b+1;c<8;++c) for(int d=c+1;d<8;++d) {
        int S[4]={C[a],C[b],C[c],C[d]}, fc=0,pc=0;
        for(int u:S) fc += sigma[u]==u;
        for(int x=0;x<4;++x) for(int y=x+1;y<4;++y) pc += sigma[S[x]]==S[y];
        int pairing[3][4]={{0,1,2,3},{0,2,1,3},{0,3,1,2}};
        for(auto &z:pairing) {
          int x=join[join[S[z[0]]][S[z[1]]]][join[S[z[2]]][S[z[3]]]];
          if(sigma[x]!=x && !occupied[join[x][sigma[x]]]) ++emptyByType[fc][pc];
        }
      }
      int em=0; for(int a=0;a<3;++a) for(int b=0;b<3;++b) {
        em+=emptyByType[a][b]; minEmptyByType[a][b]=std::min(minEmptyByType[a][b],emptyByType[a][b]);
      }
      assert(em==210-fm-om); minEmptyMoment=std::min(minEmptyMoment,em);
      int visibleMass = 0, tailR = 0, twiceT = 0;
      for (int j=0;j<=4;++j) {
        visibleMass += j * multiplicity[j];
        if (j) tailR += (j-1) * multiplicity[j];
        twiceT += j * (j-1) * multiplicity[j];
      }
      assert(visibleMass == 204-Bcorr && tailR == R && twiceT == em);
      assert(legal == Bcorr + R - 34);
      ++legalHistogram[legal];
      ++brHistogram[{Bcorr,R}];
      if (!minRByB.count(Bcorr) || R < minRByB[Bcorr]) minRByB[Bcorr] = R;
      if (!minBByR.count(R) || Bcorr < minBByR[R]) minBByR[R] = Bcorr;
      int T = em/2;
      int highCorrection = multiplicity[3] + 3*multiplicity[4];
      if (!minTByB.count(Bcorr) || T < minTByB[Bcorr]) minTByB[Bcorr] = T;
      if (!maxHighCorrectionByB.count(Bcorr) ||
          highCorrection > maxHighCorrectionByB[Bcorr])
        maxHighCorrectionByB[Bcorr] = highCorrection;
      if (!maxFixedPlusOccupiedByB.count(Bcorr) ||
          fm+om > maxFixedPlusOccupiedByB[Bcorr])
        maxFixedPlusOccupiedByB[Bcorr] = fm+om;
      auto &frontier = frontierByB[Bcorr];
      if (R < frontier.other) {
        frontier.other = R;
        frontier.fixedFirst = ff;
        frontier.occupiedFirst = of;
        frontier.emptyFirst = ef;
        frontier.fixedMoment = fm;
        frontier.occupiedMoment = om;
        frontier.emptyMoment = em;
        frontier.multiplicity = multiplicity;
      }
      if (legal == 32) {
        equalityArcs.insert({oi,oj,ok});
        ++equalityTuples[{Bcorr,R,ff,of,ef,fm,om,em,multiplicity[0],
          multiplicity[1],multiplicity[2],multiplicity[3],multiplicity[4]}];
      }
      observe(byMoments, {fm,om}, legal);
      observe(byBMoments, {Bcorr,fm,om}, legal);
      observe(byRMoments, {R,fm,om}, legal);
      observe(byFirstMoments, {ff,of,ef}, legal);
      observe(byAllMoments, {ff,of,ef,fm,om,em}, legal);
      observe(byBEmptyMoment, {Bcorr,em}, legal);
      observe(byREmptyMoment, {R,em}, legal);
      observe(byTailMultiplicity,
        {multiplicity[2],multiplicity[3],multiplicity[4]}, legal);
      observe(byFullTuple,
        {Bcorr,R,ff,of,ef,fm,om,em,multiplicity[0],multiplicity[1],
          multiplicity[2],multiplicity[3],multiplicity[4]}, legal);
      if(legal<best) {
        best=legal; bestI={oi,oj,ok};
        std::cerr<<"arcs="<<arcs<<" best="<<best<<" indices="<<oi<<","<<oj<<","<<ok<<"\n";
      }
    }
    if((ii%20)==0 && jj==ii+1) std::cerr<<"ii="<<ii<<" arcs="<<arcs<<" best="<<best<<"\n";
  }
  std::cout<<"arcs="<<arcs<<" min_legal="<<best<<" min_B="<<minB<<" min_R="<<minR
           <<" max_fixed_moment="<<maxFixedMoment<<" max_occupied_moment="<<maxOccupiedMoment
           <<" min_empty_moment="<<minEmptyMoment
           <<" A="<<key(pts[A])<<" B="<<key(pts[B])
           <<" orbit_indices="<<bestI[0]<<","<<bestI[1]<<","<<bestI[2]<<"\n";
  for(int t:bestI) std::cout<<key(pts[orb[t].first])<<" "<<key(pts[orb[t].second])<<"\n";
  for(int a=0;a<3;++a) for(int b=0;b<3;++b) if(minEmptyByType[a][b]<1000)
    std::cout<<"type f="<<a<<" pairs="<<b<<" min_empty="<<minEmptyByType[a][b]<<"\n";
  std::cout << "legal_histogram";
  for (const auto &[legal,count] : legalHistogram)
    std::cout << " " << legal << ":" << count;
  std::cout << "\nmin_R_by_B";
  for (const auto &[Bcorr,R] : minRByB) std::cout << " " << Bcorr << ":" << R;
  std::cout << "\nmin_B_by_R";
  for (const auto &[R,Bcorr] : minBByR) std::cout << " " << R << ":" << Bcorr;
  std::cout << "\nB_conditioned_moment_bounds\n";
  for (const auto &[Bcorr,R] : minRByB) {
    std::cout << "B=" << Bcorr << " minR=" << R
              << " minT=" << minTByB[Bcorr]
              << " maxHigh=" << maxHighCorrectionByB[Bcorr]
              << " separate_R_bound="
              << minTByB[Bcorr]-maxHighCorrectionByB[Bcorr]
              << " maxFixedPlusOccupied=" << maxFixedPlusOccupiedByB[Bcorr]
              << "\n";
  }
  std::cout << "\nBR_histogram";
  for (const auto &[br,count] : brHistogram)
    std::cout << " " << br[0] << "," << br[1] << ":" << count;
  std::cout << "\nfrontier_by_B\n";
  for (const auto &[Bcorr,r] : frontierByB) {
    std::cout << "B=" << Bcorr << " R=" << r.other
              << " first=" << r.fixedFirst << "," << r.occupiedFirst
              << "," << r.emptyFirst
              << " second=" << r.fixedMoment << "," << r.occupiedMoment
              << "," << r.emptyMoment << " multiplicity=";
    for (int j=0;j<=4;++j) std::cout << (j ? "," : "") << r.multiplicity[j];
    std::cout << "\n";
  }
  std::cout << "equality_tuple_count=" << equalityTuples.size() << "\n";
  for (const auto &[tuple,count] : equalityTuples) {
    std::cout << "equality count=" << count << " tuple=";
    for (size_t j=0;j<tuple.size();++j) std::cout << (j ? "," : "") << tuple[j];
    std::cout << "\n";
  }
  assert(equalityArcs.size()==1600);
  std::map<std::array<int,3>, size_t> equalityClassCounts;
  std::map<std::array<int,3>, size_t> equalityOrbitSizes;
  for (const auto &arcTriple : equalityArcs) {
    std::set<std::array<int,3>> images;
    for (const Mat &m : residualGroup) {
      std::array<int,3> image{};
      for (int j=0;j<3;++j) {
        int p = id.at(key(applyMat(m,pts[orb[arcTriple[j]].first])));
        image[j] = orbitOfPoint[p];
        assert(image[j]>=0);
      }
      std::sort(image.begin(),image.end());
      assert(equalityArcs.count(image));
      images.insert(image);
    }
    const auto canonical = *images.begin();
    ++equalityClassCounts[canonical];
    equalityOrbitSizes[canonical]=images.size();
  }
  std::cout << "equality_residual_classes=" << equalityClassCounts.size() << "\n";
  for (const auto &[canonical,count] : equalityClassCounts) {
    const size_t orbitSize=equalityOrbitSizes[canonical];
    std::cout << "class canonical=" << canonical[0] << "," << canonical[1] << ","
              << canonical[2] << " normalized_arcs=" << count
              << " orbit_size=" << orbitSize
              << " stabilizer_size=" << residualGroup.size()/orbitSize << "\n";
  }
  std::cout << "\n";
  summarize("fixedMoment,occupiedMoment", byMoments);
  summarize("B,fixedMoment,occupiedMoment", byBMoments);
  summarize("R,fixedMoment,occupiedMoment", byRMoments);
  summarize("fixedFirst,occupiedFirst,emptyFirst", byFirstMoments);
  summarize("allFirstAndSecondMoments", byAllMoments);
  summarize("B,emptyMoment", byBEmptyMoment);
  summarize("R,emptyMoment", byREmptyMoment);
  summarize("n2,n3,n4", byTailMultiplicity);
  summarize("fullTuple", byFullTuple);

  // Greedy set cover of the normalized arcs by explicit legal witness orbits.  This is only a
  // certificate generator: Lean independently checks every covered configuration.
  const size_t words = (normalizedLegalMasks.size() + 63) / 64;
  std::vector<std::vector<uint64_t>> covers(310, std::vector<uint64_t>(words));
  for (size_t i=0;i<normalizedLegalMasks.size();++i)
    for (int t=0;t<310;++t) if (normalizedLegalMasks[i].test(t)) covers[t][i/64] |= uint64_t(1) << (i%64);
  std::vector<uint64_t> uncovered(words, ~uint64_t(0));
  if (normalizedLegalMasks.size()%64)
    uncovered.back() = (uint64_t(1) << (normalizedLegalMasks.size()%64)) - 1;
  size_t remaining=normalizedLegalMasks.size(); std::vector<int> cover;
  while (remaining) {
    int choice=-1; size_t gain=0;
    for (int t=0;t<310;++t) {
      size_t ncover=0;
      for (size_t w=0;w<words;++w) ncover += __builtin_popcountll(covers[t][w] & uncovered[w]);
      if (ncover>gain) { gain=ncover; choice=t; }
    }
    assert(choice>=0 && gain>0); cover.push_back(choice);
    for (size_t w=0;w<words;++w) uncovered[w] &= ~covers[choice][w];
    remaining-=gain;
  }
  std::cout<<"normalized_arcs_with_orbit_5="<<normalizedLegalMasks.size()
           <<" greedy_cover_size="<<cover.size()<<"\n";
  for (int t:cover)
    std::cout<<"cover_orbit="<<t<<" lean_orbit_number="
             <<leanOrbitNumber(pts[orb[t].first],pts[orb[t].second])<<"\n";
}
