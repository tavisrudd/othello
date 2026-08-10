# Independent GAP replay of the A5 subgroup and character calculations.

G := AlternatingGroup(5);;
K := Stabilizer(G, 1);;
P := SylowSubgroup(G, 5);;
H := Normalizer(G, P);;
Ks := AsList(ConjugacyClassSubgroups(G, K));;
Hs := AsList(ConjugacyClassSubgroups(G, H));;

if Size(G) <> 60 or Size(K) <> 12 or Size(H) <> 10 then Error("orders"); fi;
if Length(Ks) <> 5 or Length(Hs) <> 6 then Error("subgroup classes"); fi;

pairs := Set(List(Elements(G), g -> [H^g, K^g]));;
if Length(pairs) <> 30 then Error("pair orbit"); fi;
intersectionOrders := Set(List(Cartesian(Hs, Ks), pair -> Size(Intersection(pair[1], pair[2]))));;
if intersectionOrders <> [2] then Error("intersections"); fi;
pairStabilizer := Intersection(H, K);;
if Size(Normalizer(G, pairStabilizer)) / Size(pairStabilizer) <> 2 then Error("pair involution"); fi;

perm5 := PermutationCharacter(G, K);;
perm6 := PermutationCharacter(G, H);;
triv := TrivialCharacter(G);;
V4 := perm5 - triv;;
W5 := perm6 - triv;;
if ScalarProduct(V4, W5) <> 0 then Error("Hom(V4,W5)"); fi;
if ScalarProduct(RestrictedClassFunction(V4, K), TrivialCharacter(K)) <> 1 then Error("V4^A4"); fi;
if ScalarProduct(RestrictedClassFunction(W5, H), TrivialCharacter(H)) <> 1 then Error("W5^D5"); fi;
carrier := V4 * W5;;
degrees := List(Irr(G), chi -> chi[1]);;
multiplicities := List(Irr(G), chi -> ScalarProduct(carrier, chi));;
if Collected(List([1..Length(degrees)], i -> [degrees[i],multiplicities[i]])) = [] then Error("unreachable"); fi;
if Sum([1..Length(degrees)], i -> degrees[i] * multiplicities[i]) <> 20 then Error("carrier decomposition"); fi;

ordinaryTable := CharacterTable("A5");;
brauer5 := BrauerTable(ordinaryTable, 5);;
decomposition5 := DecompositionMatrix(brauer5);;
ordinaryDegrees := List(Irr(ordinaryTable), chi -> chi[1]);;
goldenPositions := Positions(ordinaryDegrees, 3);;
if Length(goldenPositions) <> 2 then Error("golden positions"); fi;
if decomposition5[goldenPositions[1]] <> [0,1,0]
   or decomposition5[goldenPositions[2]] <> [0,1,0] then
  Error("golden mod-5 fusion");
fi;
if List(Irr(brauer5), chi -> chi[1]) <> [1,3,5] then Error("Brauer degrees"); fi;

Print("PASS independent GAP replay\n");
Print("A5=", Size(G), " A4-class=", Length(Ks), " D5-class=", Length(Hs), " pairs=", Length(pairs), "\n");
Print("intersection orders=", intersectionOrders, " <V4,W5>=", ScalarProduct(V4,W5), "\n");
Print("pair involution quotient=", Size(Normalizer(G,pairStabilizer))/Size(pairStabilizer), "\n");
Print("fixed dimensions V4^A4=", ScalarProduct(RestrictedClassFunction(V4,K),TrivialCharacter(K)),
      " W5^D5=", ScalarProduct(RestrictedClassFunction(W5,H),TrivialCharacter(H)), "\n");
Print("irreducible degrees=", degrees, " carrier multiplicities=", multiplicities, "\n");
Print("mod-5 Brauer degrees=", List(Irr(brauer5), chi -> chi[1]),
      " both golden 3s -> [0,1,0]\n");
